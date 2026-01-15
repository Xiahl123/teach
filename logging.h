// 使用 spdlog 实现简单的全局异步日志配置 
// 1. 基本使用方法
//    1. 当使用fork启动子进程时，需要在子进程中初始化日志线程：init_logging("plc_forwarder");不初始化使用会导致系统崩溃
//    2. 在cmake的target_include_directories中添加：${CMAKE_SOURCE_DIR}，方便访问logging.h
//    target_include_directories{
//       原有的部分
//       ${CMAKE_SOURCE_DIR}
//    }
//    2. 在需要用到的源文件里包含：
//    #include "logging.h"
//    3. 在进程启动时（一次）初始化，例如：
//    init_logging("<<log_name>>"，“<<log_save_path>>”);
//    4. 之后在任何地方直接用：
//    spdlog::info("value = {}", v);
//    spdlog::warn("something maybe wrong");
//    spdlog::error("error code = {}", code);
//    spdlog::debug("debug detail: {}", detail);
//    日志会异步写入 logs/<logger_name>.log（每天一个新文件，最多保留 30 天），不会打印到控制台。
// 2. 使用当前线程写入，每秒写入行数应控制在100以内，避免影响写入线程效率，注意调用频率
// 3. 日志文件命令方式为:log_name_日期.log，如果没有特殊设定，日志在build/logs目录下
// 4. 日志级别的优先级关系
//    按照“严重程度从高到低”排，一般（包括 spdlog）是：
//    critical / fatal：致命错误，程序已经或马上不能继续运行（比如配置缺失、重要资源不可用）。
//    error：错误，当前操作失败，需要修复（例如网络请求失败、解码失败）。
//    warn / warning：警告，暂时还能继续，但状态异常或可能引发问题（例如重试、性能过高、参数异常但被纠正）。
//    info：信息，正常业务流程中的关键节点（启动、连接成功、重要状态变化）。
//    debug：调试信息，帮助开发者理解内部流程，通常在开发阶段开启。
//    trace：最细粒度的调试信息，几乎每个步骤都记录，一般只在排查疑难问题时短时间开启。
//    日志级别的过滤规则（以 spdlog 为例）
//    当你设置：
//    spdlog::set_level(spdlog::level::info);
//    会输出：info, warn, error, critical
//    不会输出：debug, trace

#pragma once

#include <chrono>
#include <iomanip>
#include <iostream>
#include <memory>
#include <sstream>
#include <string>
#include <vector> 

// 兼容 C++17 及以下版本的 filesystem 支持 
#if __cplusplus >= 201703L
    #include <filesystem>
    namespace fs = std::filesystem;
#else
    #include <experimental/filesystem>
    namespace fs = std::experimental::filesystem;
#endif

#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>

inline void init_logging(const std::string &logger_name,
                         const std::string &log_dir_name = "logs") {
    try {
        // Ensure log directory exists
        fs::path log_dir(log_dir_name);
        if (!fs::exists(log_dir)) {
            fs::create_directories(log_dir);
        }

        // 清理 logs 目录下超过 30 天的旧日志文件
        try {
            using file_clock = fs::file_time_type::clock;
            auto now_file = file_clock::now();
            auto expire_time = now_file - std::chrono::hours(24 * 30);

            for (const auto &entry : fs::directory_iterator(log_dir)) {
                auto path = entry.path();
                if (!fs::is_regular_file(path)) {
                    continue;
                }
                auto ftime = fs::last_write_time(path);
                if (ftime < expire_time) {
                    fs::remove(path);
                }
            }
        } catch (const std::exception &) {
            // 忽略清理日志时的错误，避免影响主流程
        }
        auto now = std::chrono::system_clock::now();
        std::time_t t = std::chrono::system_clock::to_time_t(now);
        std::tm tm{};
#if defined(_WIN32)
        localtime_s(&tm, &t);
#else
        localtime_r(&t, &tm);
#endif
        std::ostringstream oss;
        oss << std::put_time(&tm, "%Y-%m-%d");
        std::string date_str = oss.str();

        // 日志文件路径：<log_dir>/<logger_name>_YYYY-MM-DD.log 
        fs::path log_file = log_dir / 
                           (logger_name + "_" + date_str + ".log");

        // 创建文件 sink，用于写入日志文件
        auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(
            log_file.string(),            // 指定日志文件路径字符串
            false                         // truncate = false，若文件存在则追加写入，否则新建
        );
        file_sink->set_level(spdlog::level::info);   // 文件 sink 记录 info 及以上级别

        // 创建控制台 sink，用于彩色输出到终端
        auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
        console_sink->set_level(spdlog::level::trace); // 控制台输出全部日志

        // 使用 vector 保存 sink 列表（文件 + 控制台）
        std::vector<spdlog::sink_ptr> sinks;
        sinks.push_back(file_sink);
        sinks.push_back(console_sink);
        // 创建同步 logger 对象的智能指针
        auto logger = std::make_shared<spdlog::logger>(                
            logger_name,
            sinks.begin(), sinks.end());
        // 设置 logger 的最低输出级别为 debug
        logger->set_level(spdlog::level::debug);                       
        // 设置日志输出的格式字符串
        logger->set_pattern(                                           
            "[%Y-%m-%d %H:%M:%S.%e] [%^%l%$] [thread %t] %v");
        // 当输出 info 级别及以上日志时立刻刷新
        logger->flush_on(spdlog::level::info);                         
        // 将此 logger 设置为 spdlog 的全局默认 logger
        spdlog::set_default_logger(logger);                            
        // 记录一条 info 日志，说明 logger 初始化完成，证明启动了程序
        spdlog::info("Logger '{}' initialized. Log directory: {}",     
                     logger_name, log_dir.string());
    } catch (const spdlog::spdlog_ex &ex) {
        std::cerr << "Failed to initialize logging: " << ex.what()
                  << std::endl;
    } catch (const std::exception &ex) {
        std::cerr << "Exception while initializing logging: "
                  << ex.what() << std::endl;
    }
}

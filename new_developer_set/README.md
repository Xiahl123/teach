## 一键环境安装脚本说明（Ubuntu 24.04）

本项目提供了一个用于新装 Ubuntu 24.04 工作站的**一键环境初始化脚本**，可自动完成 CUDA/TensorRT、OpenCV、Qt、常用 C++ 库、Miniconda + TensorRT 模型转换环境，以及项目代码仓库的拉取与模型部署等工作。

脚本已根据 `remote环境安装` 文档和实际工程（`remote_cockpit`、`crane-3d-platform`）定制。

---

### 一、文件结构

- **`install_remote_env.sh`**  
  主入口脚本，负责：
  - 初始化日志（默认目录：`~/remote_env_logs`）
  - 定义公共函数（`step`、`require_cmd`、`detect_trtexec` 等）
  - 依次 `source` `steps/` 下的各个步骤脚本

- **`steps/` 目录**（每个文件对应一个步骤）：
  - `step_1_build_env.sh`：安装 C++ 编译环境与基础开发依赖
  - `step_1_1_docker.sh`：安装 Docker（官方仓库）及 docker-compose 插件
  - `step_2_cuda_tensorrt.sh`：安装 NVIDIA 驱动、CUDA Toolkit、TensorRT，并写入 CUDA 环境变量
  - `step_3_opencv.sh`：从源码编译安装带 CUDA 的 OpenCV
  - `step_4_qt.sh`：安装 Qt5 + 多媒体、WebEngine 组件
  - `step_5_libs.sh`：安装 Boost、jsoncpp、yaml-cpp、dlib、OpenSSL、RandR、Xinerama、BLAS/LAPACK、SQLite3 等库
  - `step_6_miniconda_env.sh`：安装 Miniconda 并创建 `tensorrt` 环境，安装 `tensorrt_yolo / torch / ultralytics / onnx / onnx-simplifier`
  - `step_7_yolo_convert.sh`：自动执行 YOLO -> ONNX -> TensorRT engine 的三模型转换（yolo11m-p / yolo12x-v1.4-nov-300 / yolo11m-v0.22-aug-300）
  - `step_8_remote_cockpit.sh`：在 `~/Documents/cockpit_software` 克隆 `HKCRC/remote_cockpit`，切换到 `huiyang_apply` 分支、更新子模块，并整理 engine 文件到 `models/tensorrt`
  - `step_9_crane_3d_platform.sh`：在 `~/Documents` 克隆并更新 `dubinbin/crane-3d-platform`（3D 防碰撞前端），检查配置文件后执行 `docker-start.sh`

---

### 二、运行前准备

1. **确认系统版本**
   - 推荐：Ubuntu 24.04 x86_64（脚本会尽量兼容 22.04，但未完全验证）。

2. **确保用户具备 sudo 权限**
   - 当前用户需要可以无障碍执行 `sudo`（部分步骤会多次调用）。

3. **准备 GitHub Token（GITHUB_KEY）**
   - 用于访问以下私有或受限仓库：
     - `https://github.com/HKCRC/remote_cockpit.git`
     - `https://github.com/dubinbin/crane-3d-platform.git`（如为私有）  
   - Token 在步骤执行时只保存在当前进程内存，不写入磁盘，使用完会 `unset`。

4. **准备 YOLO 模型文件（可选但推荐）**
   - 默认模型目录：`/home/craner/Documents/remote_cockpit_cpu_exit_20250911/ai_detect/tensorrt`
   - 期望存在的 `.pt` 模型：
     - `yolo11m-p.pt`
     - `yolo12x-v1.4-nov-300.pt`
     - `yolo11m-v0.22-aug-300.pt`
   - 若路径或文件名不同，运行时可在第 7 步修改模型目录。

---

### 三、一键运行方式

在项目根目录执行：

```bash
cd /home/hkcrc/Documents/new_system_init
chmod +x ./install_remote_env.sh
./install_remote_env.sh
```

脚本会从第 1 步顺序执行到第 9 步，并将**全部输出**写入日志文件：

```bash
~/remote_env_logs/remote_env_install_YYYY-MM-DD_HH-MM-SS.log
```

如中途某步失败，可根据日志排查问题，修正后重新执行脚本（会自动跳过已安装完成的大部分步骤，或由你手动编辑某些步骤脚本进行微调）。

---

### 四、各步骤详细说明

- **步骤 1：C++ 构建环境**
  - 安装 `build-essential / cmake / git / pkg-config` 等基础工具
  - 安装 FFmpeg/视频相关依赖（`libavcodec-dev` 等）
  - 安装图像、线性代数、GTK 等基础库

- **步骤 1.1：Docker 安装（官方源）**
  - 添加 Docker 官方 GPG key 与 apt 源
  - 安装 `docker-ce / docker-ce-cli / containerd.io / docker-buildx-plugin / docker-compose-plugin`
  - 创建 `docker` 组并将当前用户加入（需重新登录/重开终端生效）

- **步骤 2：CUDA & TensorRT**
  - 自动安装开源 NVIDIA 驱动（优先 `nvidia-driver-580-open`，失败退回 `570-open`）
  - 根据系统版本配置 CUDA 源并安装最新 `cuda-toolkit`
  - 自动写入 `~/.bashrc`：
    - `export CUDA_HOME=/usr/local/cuda-12.8`（若存在）或解析当前 `/usr/local/cuda` 链接
    - `export PATH=$CUDA_HOME/bin:$PATH`
    - `export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH`
  - 安装 TensorRT 及常用开发包，并打印已安装版本

- **步骤 3：OpenCV + CUDA**
  - 自动检测 GPU Compute Capability（无法检测则使用 8.6，可通过 `CUDA_ARCH_BIN` 覆盖）
  - 克隆 `opencv` 和 `opencv_contrib`，开启 CUDA 相关选项并编译安装
  - 刷新 `ldconfig` 并写入 `/etc/ld.so.conf.d/opencv.conf`

- **步骤 4：Qt5**
  - 安装 `qtcreator / qtbase5-dev / qtmultimedia5-dev / qtwebengine5-dev` 等

- **步骤 5：常用 C++/数学/系统库**
  - 安装 Boost、jsoncpp、yaml-cpp、dlib、OpenSSL、RandR、Xinerama、BLAS/LAPACK、SQLite3 等

- **步骤 6：Miniconda + TensorRT 转换环境**
  - 静默安装 Miniconda 至 `~/miniconda3`
  - `conda init bash` 且关闭自动激活 base 环境
  - 创建/更新 `tensorrt` 环境（Python 3.9）
  - 在该环境中安装：`tensorrt_yolo / torch / ultralytics / onnx / onnx-simplifier`

- **步骤 7：YOLO -> TensorRT 模型自动转换**
  - 自动/交互式确定 `trtexec` 路径（PATH 中或常见安装路径，若失败则提示手动输入）
  - 询问模型目录（带默认路径），检查三个 `.pt` 文件是否存在
  - 对存在的模型依次执行：
    - `trtyolo export` 生成 `.onnx`
    - `trtexec` 生成 `.engine`（其中 yolo11m-v0.22-aug-300 带 TensorRT-YOLO 自定义插件）

- **步骤 8：remote_cockpit 仓库 & engine 目录**
  - 在 `~/Documents/cockpit_software` 下克隆或更新 `HKCRC/remote_cockpit`，并切到 `huiyang_apply` 分支
  - 更新子模块
  - 创建：
    - `build/`
    - `models/tensorrt/`
    - `config/`
  - 将第 7 步生成的三个 `.engine` 文件（若存在）移动到 `models/tensorrt/`

- **步骤 9：运行 3D 防碰撞系统（crane-3d-platform）**
  - 在 `~/Documents` 下克隆或更新 [`dubinbin/crane-3d-platform`](https://github.com/dubinbin/crane-3d-platform.git)
  - 检查配置文件：
    - 默认：`$HOME/app/public/json/index.json`
  - 若配置存在：
    - 在仓库目录执行 `sudo sh ./docker-start.sh`，启动前端 Docker 服务
  - 若配置不存在：
    - 输出提示，要求先准备好 `index.json` 再手动执行启动脚本

---

### 五、分步执行（可选）

如需要只执行某一步，可仿照主脚本，在终端中手动 `source` 对应步骤脚本（需保证当前 shell 中已加载公共函数）：

```bash
cd /home/hkcrc/Documents/new_system_init
source ./install_remote_env.sh  # 或手动 source 公共函数部分

# 单独运行第 3 步（OpenCV 安装）
. ./steps/step_3_opencv.sh
```

实际使用中推荐直接运行 `./install_remote_env.sh`，让脚本自动按顺序跑完全部步骤。 



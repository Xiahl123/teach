# vscode 操作
## 新建 .vscode,保存以下内容
### launch.json
用于启动代码发送的命令
## debug当vscode 代码提示无法找到头文件时
按住：ctrl+shift+p 找到Edit Configurations(JSON)
确认后会出现 .vscode/c_cpp_properties.json文件，在该文件中配置includePath即可
配置形式形如：
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/**",
                "/usr/include/c++/11/**",
                "/usr/include/x86_64-linux-gnu/c++/11/**",
                "/usr/include/c++/11/backward/**",
                "/usr/lib/gcc/x86_64-linux-gnu/11/include/**",
                "/usr/local/include/**",
                "/usr/include/x86_64-linux-gnu/**",
                "/usr/include/**",
                "/opt/ros/humble/include/**",
                "leftWindow/**",
                "rightWindow/**",
                "videoWindow/**",
                "ros2/**"
            ],
            "defines": [],
            "compilerPath": "/usr/bin/clang-14",
            "cStandard": "c17",
            "cppStandard": "c++14",
            "intelliSenseMode": "linux-gcc-x64"
        }
    ],
    "version": 4
}

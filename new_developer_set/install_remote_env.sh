#!/usr/bin/env bash

###############################################################################
# 一键环境安装脚本（参考 remote环境安装）
# 适用：Ubuntu 24.04（也尽量兼容 22.04）
#
# 功能：
#   - 按步骤安装 C++/CUDA/TensorRT/OpenCV/Qt5/常用库/RealSense/Miniconda 环境
#   - 自动将所有终端输出记录到日志文件
#
# 使用方法：
#   1) 赋予执行权限：
#        chmod +x ./install_remote_env.sh
#   2) 运行脚本（建议普通用户运行，脚本内部会自行使用 sudo）：
#        ./install_remote_env.sh
#
# 日志文件默认保存在：$HOME/remote_env_logs/remote_env_install_YYYY-MM-DD_HH-MM-SS.log
###############################################################################

set -euo pipefail

#######################################
# 日志与基础信息
#######################################
LOG_DIR="${LOG_DIR:-"$HOME/remote_env_logs"}"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/remote_env_install_$(date +%F_%H-%M-%S).log"

# 同时输出到终端与日志文件
exec > >(tee -a "$LOG_FILE") 2>&1

step() {
  echo
  echo "======================================================================"
  echo ">>> $*"
  echo "======================================================================"
}

echo "日志文件: $LOG_FILE"
echo "开始安装时间: $(date)"
echo "当前用户: $(whoami)"
echo "系统版本:"
lsb_release -a 2>/dev/null || cat /etc/os-release || true

#######################################
# 辅助函数
#######################################
require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "错误: 未找到命令 '$1'，请先安装后重试。"
    exit 1
  fi
}

# 自动检测 trtexec 可执行文件路径
detect_trtexec() {
  # 1) 如果在 PATH 中可见，优先使用
  if command -v trtexec >/dev/null 2>&1; then
    command -v trtexec
    return 0
  fi

  # 2) 常见安装路径
  local candidates=(
    "/usr/src/tensorrt/bin/trtexec"
    "/usr/local/TensorRT-10.8.0.43/bin/trtexec"
    "/usr/local/TensorRT/bin/trtexec"
  )

  local p
  for p in "${candidates[@]}"; do
    if [ -x "$p" ]; then
      echo "$p"
      return 0
    fi
  done

  # 未找到返回空
  return 1
}

#######################################
# 步骤调度：按顺序调用拆分的步骤脚本
#######################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1.x 基础开发环境 & Docker
. "${SCRIPT_DIR}/steps/step_1_build_env.sh"
. "${SCRIPT_DIR}/steps/step_1_1_docker.sh"

# 2. CUDA / TensorRT
. "${SCRIPT_DIR}/steps/step_2_cuda_tensorrt.sh"

# 3. OpenCV
. "${SCRIPT_DIR}/steps/step_3_opencv.sh"

# 4. Qt5
. "${SCRIPT_DIR}/steps/step_4_qt.sh"

# 5. 常用 C++/数学/系统库
. "${SCRIPT_DIR}/steps/step_5_libs.sh"

# 6. Miniconda + TensorRT 转换环境
. "${SCRIPT_DIR}/steps/step_6_miniconda_env.sh"

# 7. YOLO -> TensorRT 自动转换（三个模型）
. "${SCRIPT_DIR}/steps/step_7_yolo_convert.sh"

# 8. 克隆 remote_cockpit 并准备 engine 目录
. "${SCRIPT_DIR}/steps/step_8_remote_cockpit.sh"

# 9. 运行 3D 防碰撞系统（crane-3d-platform）
. "${SCRIPT_DIR}/steps/step_9_crane_3d_platform.sh"

#######################################
# 结束
#######################################
echo
echo "======================================================================"
echo "所有步骤执行完毕。"
echo "完整日志已保存到: ${LOG_FILE}"
echo "如果中途有报错，请根据日志内容修正后重新运行本脚本。"
echo "======================================================================"



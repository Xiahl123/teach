#!/usr/bin/env bash

#######################################
# 2. 安装 CUDA 驱动、Toolkit、TensorRT
#######################################

step "2.1 安装 NVIDIA 开源驱动（如检测到 NVIDIA GPU）"

if lspci | grep -i nvidia >/dev/null 2>&1; then
  echo "检测到 NVIDIA GPU，尝试安装开源驱动包。"
  # 优先尝试 580-open，其次 570-open；如都失败则提示用户手动从“附加驱动”中选择
  if ! sudo DEBIAN_FRONTEND=noninteractive apt install -y nvidia-driver-580-open; then
    echo "nvidia-driver-580-open 安装失败，尝试安装 nvidia-driver-570-open ..."
    if ! sudo DEBIAN_FRONTEND=noninteractive apt install -y nvidia-driver-570-open; then
      echo "自动安装 NVIDIA 驱动失败，请在 ‘Software & Updates -> Additional Drivers’ 中手动选择合适驱动。"
    fi
  fi
else
  echo "未检测到 NVIDIA GPU（lspci 中无 NVIDIA），跳过驱动安装。"
fi

step "2.2 安装 CUDA Toolkit（自动安装最新版本）"

require_cmd wget
UBUNTU_VER_NUM="$(lsb_release -rs 2>/dev/null | tr -d '.' || echo '2404')"
CUDA_REPO_VER_DEFAULT="ubuntu${UBUNTU_VER_NUM}"
CUDA_REPO_VER="${CUDA_REPO_VER:-$CUDA_REPO_VER_DEFAULT}"
CUDA_KEYRING_PKG="${CUDA_KEYRING_PKG:-cuda-keyring_1.1-1_all.deb}"
# 使用 cuda-toolkit 安装最新版本，而不是固定版本
CUDA_TOOLKIT_PKG="${CUDA_TOOLKIT_PKG:-cuda-toolkit}"

echo "使用 CUDA 仓库标识: ${CUDA_REPO_VER}"
echo "将安装最新版本的 CUDA Toolkit (${CUDA_TOOLKIT_PKG})"

wget -c "https://developer.download.nvidia.com/compute/cuda/repos/${CUDA_REPO_VER}/x86_64/${CUDA_KEYRING_PKG}" -O "${CUDA_KEYRING_PKG}"
sudo dpkg -i "${CUDA_KEYRING_PKG}" || true
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${CUDA_TOOLKIT_PKG}" || {
  echo "安装 ${CUDA_TOOLKIT_PKG} 失败，请检查当前驱动支持的 CUDA 最高版本（nvidia-smi）后，手动调整 CUDA_TOOLKIT_PKG 环境变量重试。"
  echo "可使用 'apt-cache search cuda-toolkit' 查看可用版本。"
}

#######################################
# 写入 CUDA 环境变量到 ~/.bashrc
#######################################

# 显示已安装的 CUDA 版本
if command -v nvcc >/dev/null 2>&1; then
  echo "已安装 CUDA 版本: $(nvcc --version | grep release)"
elif [ -f /usr/local/cuda/version.json ]; then
  echo "已安装 CUDA 版本: $(cat /usr/local/cuda/version.json)"
fi

# 选择合适的 CUDA_HOME（优先使用版本目录，兼容 12.8 习惯）
CUDA_HOME_DEFAULT="/usr/local/cuda"
if [ -d "/usr/local/cuda-12.8" ]; then
  CUDA_HOME_DEFAULT="/usr/local/cuda-12.8"
elif [ -L "/usr/local/cuda" ]; then
  # 如 /usr/local/cuda 是指向具体版本目录的符号链接，则解析真实路径
  CUDA_HOME_DEFAULT="$(readlink -f /usr/local/cuda || echo /usr/local/cuda)"
fi

CUDA_HOME="${CUDA_HOME:-$CUDA_HOME_DEFAULT}"

echo "准备将 CUDA 环境变量写入 ~/.bashrc："
echo "  CUDA_HOME=${CUDA_HOME}"
echo "  PATH=\$CUDA_HOME/bin:\$PATH"
echo "  LD_LIBRARY_PATH=\$CUDA_HOME/lib64:\$LD_LIBRARY_PATH"

BASHRC_FILE="$HOME/.bashrc"

append_if_not_exists() {
  local pattern="$1"
  local line="$2"
  if ! grep -Fq "$pattern" "$BASHRC_FILE" 2>/dev/null; then
    echo "$line" >> "$BASHRC_FILE"
  fi
}

append_if_not_exists "CUDA_HOME=" "export CUDA_HOME=${CUDA_HOME}"
append_if_not_exists "CUDA_HOME/bin" 'export PATH=$CUDA_HOME/bin:$PATH'
append_if_not_exists "CUDA_HOME/lib64" 'export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH'

echo "CUDA 环境变量已追加到 ~/.bashrc，重新打开终端或执行 'source ~/.bashrc' 后生效。"

step "2.3 安装 TensorRT（自动安装最新版本）"

# 先尝试当前系统版本的 CUDA 仓库 key，不行再回退到 ubuntu2204
if ! sudo apt-key adv --fetch-keys "https://developer.download.nvidia.com/compute/cuda/repos/${CUDA_REPO_VER}/x86_64/3bf863cc.pub"; then
  echo "从 ${CUDA_REPO_VER} 获取 TensorRT key 失败，尝试使用 ubuntu2204 仓库 key。"
  sudo apt-key adv --fetch-keys "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub" || true
fi

if ! sudo add-apt-repository -y "deb https://developer.download.nvidia.com/compute/cuda/repos/${CUDA_REPO_VER}/x86_64/ /"; then
  echo "添加 ${CUDA_REPO_VER} TensorRT 源失败，尝试添加 ubuntu2204 源。"
  sudo add-apt-repository -y "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" || true
fi

sudo apt update

echo "正在查询最新可用的 TensorRT 版本..."
echo "可用版本列表（前10个）:"
apt-cache madison tensorrt 2>/dev/null | head -10 || true

# 安装最新版本的 TensorRT（不指定版本号，apt 会自动选择最新版本）
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  tensorrt \
  libnvinfer-dev \
  libnvinfer-plugin-dev \
  libnvonnxparsers-dev \
  libnvinfer-samples \
  libnvinfer-headers-dev \
  libnvinfer-headers-plugin-dev \
  python3-libnvinfer-dev \
  python3-libnvinfer \
  --allow-downgrades --fix-missing || {
    echo "部分 TensorRT 包安装失败，尝试只安装核心包..."
    sudo DEBIAN_FRONTEND=noninteractive apt install -y tensorrt --allow-downgrades --fix-missing || {
      echo "TensorRT 安装失败，请根据日志手动处理依赖冲突。"
      echo "可使用 'apt-cache search tensorrt' 查看可用包。"
    }
  }

# 显示已安装的 TensorRT 版本
if dpkg -l | grep -q tensorrt; then
  echo "已安装 TensorRT 版本:"
  dpkg -l | grep -E "^ii\s+tensorrt" | awk '{print $2, $3}'
fi



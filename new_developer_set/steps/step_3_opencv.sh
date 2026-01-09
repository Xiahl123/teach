#!/usr/bin/env bash

#######################################
# 3. 从源码编译安装 OpenCV（启用 CUDA）
#######################################
step "3. 安装 OpenCV（含 CUDA 支持）"

# 自动检测 GPU 计算能力（Compute Capability）
detect_cuda_arch() {
  if command -v nvidia-smi >/dev/null 2>&1; then
    local arch
    arch=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader 2>/dev/null | head -1 | tr -d ' ')
    if [ -n "$arch" ]; then
      echo "$arch"
      return 0
    fi
  fi
  # 无法检测，返回默认值
  echo "警告: 无法检测 GPU 架构，使用默认值 8.6" >&2
  echo "8.6"
}

# 检测或使用用户指定的 CUDA_ARCH_BIN
if [ -z "${CUDA_ARCH_BIN:-}" ]; then
  echo "正在检测 GPU 计算能力..."
  CUDA_ARCH_BIN=$(detect_cuda_arch)
  echo "检测到 CUDA_ARCH_BIN=${CUDA_ARCH_BIN}"
else
  echo "使用用户指定的 CUDA_ARCH_BIN=${CUDA_ARCH_BIN}"
fi
echo "如需修改，可在运行脚本前导出环境变量，例如：export CUDA_ARCH_BIN=8.6"

OPENCV_SRC_DIR="${OPENCV_SRC_DIR:-$HOME/opencv}"
OPENCV_CONTRIB_DIR="${OPENCV_CONTRIB_DIR:-$HOME/opencv_contrib}"

if [ ! -d "$OPENCV_SRC_DIR" ]; then
  git clone https://github.com/opencv/opencv.git "$OPENCV_SRC_DIR"
fi

if [ ! -d "$OPENCV_CONTRIB_DIR" ]; then
  git clone https://github.com/opencv/opencv_contrib.git "$OPENCV_CONTRIB_DIR"
fi

mkdir -p "$OPENCV_SRC_DIR/build"
cd "$OPENCV_SRC_DIR/build"

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D OPENCV_EXTRA_MODULES_PATH="${OPENCV_CONTRIB_DIR}/modules" \
      -D BUILD_EXAMPLES=ON \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN="${CUDA_ARCH_BIN}" \
      -D CUDA_ARCH_PTX="" \
      -D WITH_CUDNN=OFF \
      -D OPENCV_DNN_CUDA=OFF \
      -D WITH_GTK=ON ..

make -j"$(nproc)"
sudo make install

# 刷新动态库链接
sudo ldconfig

# 写入 OpenCV 库路径配置（替代手工 nano 编辑）
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/opencv.conf >/dev/null
sudo ldconfig



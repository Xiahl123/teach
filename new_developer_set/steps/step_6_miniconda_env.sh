#!/usr/bin/env bash

#######################################
# 6. 安装 Miniconda 并配置 TensorRT 模型转换环境
#######################################
step "6. 安装 Miniconda 并创建 TensorRT 模型转换环境"

MINICONDA_DIR="${MINICONDA_DIR:-$HOME/miniconda3}"
MINICONDA_SH="Miniconda3-latest-Linux-x86_64.sh"

if [ ! -d "$MINICONDA_DIR" ]; then
  echo "下载 Miniconda 安装脚本 ..."
  wget -c "https://repo.anaconda.com/miniconda/${MINICONDA_SH}" -O "${MINICONDA_SH}"
  echo "以静默方式安装 Miniconda 到 ${MINICONDA_DIR} ..."
  bash "${MINICONDA_SH}" -b -p "${MINICONDA_DIR}"
else
  echo "检测到已存在的 Miniconda 目录：${MINICONDA_DIR}，跳过重新安装。"
fi

export PATH="${MINICONDA_DIR}/bin:${PATH}"
require_cmd conda

# 初始化 shell（不会影响当前脚本执行，但方便后续登录使用）
conda init bash || true

# 禁用打开终端时自动激活 base 环境
conda config --set auto_activate_base false

echo "创建/更新名为 'tensorrt' 的 Conda 环境（Python 3.9） ..."
conda create -n tensorrt python=3.9 -y

echo "在 tensorrt 环境中安装 Python 包（tensorrt_yolo / torch / ultralytics / onnx）..."
conda run -n tensorrt pip install -U tensorrt_yolo
conda run -n tensorrt pip install torch
conda run -n tensorrt pip install ultralytics
conda run -n tensorrt pip install onnx
conda run -n tensorrt pip install onnx-simplifier



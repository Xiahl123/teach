#!/usr/bin/env bash

#######################################
# 7. YOLO -> TensorRT 模型自动转换（yolo11m-p / yolo12x-v1.4-nov-300 / yolo11m-v0.22-aug-300）
#######################################
step "7. YOLO -> TensorRT 模型自动转换（东涌电脑三模型）"

require_cmd conda

# 1) 自动检测 trtexec 路径
TRTEXEC_PATH="$(detect_trtexec || true)"

if [ -z "$TRTEXEC_PATH" ]; then
  echo "未能自动找到 trtexec，可执行文件不在 PATH 中或常见目录。"
  read -rp "请手动输入 trtexec 的完整路径 (例如 /usr/src/tensorrt/bin/trtexec 或 /usr/local/TensorRT-10.8.0.43/bin/trtexec): " TRTEXEC_PATH
fi

if [ ! -x "$TRTEXEC_PATH" ]; then
  echo "警告: 提供的 trtexec 路径无效或不可执行：$TRTEXEC_PATH"
  echo "将跳过自动 engine 转换，仅执行 trtyolo 导出 onnx。"
  TRTEXEC_PATH=""
else
  echo "已检测到 trtexec 路径：$TRTEXEC_PATH"
fi

# 2) 让用户输入模型目录，保留默认地址
DEFAULT_MODEL_DIR="/home/craner/Documents/remote_cockpit_cpu_exit_20250911/ai_detect/tensorrt"
echo
echo "请输入模型所在目录（回车使用默认）："
echo "默认：${DEFAULT_MODEL_DIR}"
read -rp "模型目录: " MODEL_DIR
if [ -z "$MODEL_DIR" ]; then
  MODEL_DIR="$DEFAULT_MODEL_DIR"
fi
MODEL_DIR="${MODEL_DIR%/}"

echo "使用的模型目录为：${MODEL_DIR}"

if [ ! -d "$MODEL_DIR" ]; then
  echo "警告: 模型目录不存在：${MODEL_DIR}，跳过自动转换。"
else
  # 3) 检查三个模型文件是否存在
  MODELS_FOUND=false

  Y11_P="${MODEL_DIR}/yolo11m-p.pt"
  Y12_X="${MODEL_DIR}/yolo12x-v1.4-nov-300.pt"
  Y11_AUG="${MODEL_DIR}/yolo11m-v0.22-aug-300.pt"

  echo
  echo "检查模型文件是否存在："
  if [ -f "$Y11_P" ]; then
    echo "  [OK] $(basename "$Y11_P")"
    MODELS_FOUND=true
  else
    echo "  [缺失] $(basename "$Y11_P")"
  fi

  if [ -f "$Y12_X" ]; then
    echo "  [OK] $(basename "$Y12_X")"
    MODELS_FOUND=true
  else
    echo "  [缺失] $(basename "$Y12_X")"
  fi

  if [ -f "$Y11_AUG" ]; then
    echo "  [OK] $(basename "$Y11_AUG")"
    MODELS_FOUND=true
  else
    echo "  [缺失] $(basename "$Y11_AUG")"
  fi

  if [ "$MODELS_FOUND" = false ]; then
    echo "未找到任意一个指定的 .pt 模型文件，跳过自动转换。"
  else
    echo
    echo "检测到至少一个模型文件，立即开始在 'tensorrt' 环境中依次转换模型 ..."

    # yolo11m-p
    if [ -f "$Y11_P" ]; then
      echo
      echo ">>> 处理 yolo11m-p.pt ..."
      conda run -n tensorrt trtyolo export -w "$Y11_P" -v yolo11 -o "${MODEL_DIR}/" -b 1 -s --imgsz 736 --iou_thres=0.3 --conf_thres=0.3

      ONNX="${MODEL_DIR}/yolo11m-p.onnx"
      ENGINE="${MODEL_DIR}/yolo11m-p.engine"
      if [ -n "$TRTEXEC_PATH" ] && [ -f "$ONNX" ]; then
        echo ">>> 使用 trtexec 转换 yolo11m-p.onnx -> yolo11m-p.engine ..."
        "$TRTEXEC_PATH" --onnx="$ONNX" --saveEngine="$ENGINE" --fp16
      fi
    fi

    # yolo12x-v1.4-nov-300
    if [ -f "$Y12_X" ]; then
      echo
      echo ">>> 处理 yolo12x-v1.4-nov-300.pt ..."
      conda run -n tensorrt trtyolo export -w "$Y12_X" -v ultralytics -o "${MODEL_DIR}/" -b 1 -s --imgsz 736 --iou_thres=0.3 --conf_thres=0.3

      ONNX="${MODEL_DIR}/yolo12x-v1.4-nov-300.onnx"
      ENGINE="${MODEL_DIR}/yolo12x-v1.4-nov-300.engine"
      if [ -n "$TRTEXEC_PATH" ] && [ -f "$ONNX" ]; then
        echo ">>> 使用 trtexec 转换 yolo12x-v1.4-nov-300.onnx -> yolo12x-v1.4-nov-300.engine ..."
        "$TRTEXEC_PATH" --onnx="$ONNX" --saveEngine="$ENGINE" --fp16
      fi
    fi

    # yolo11m-v0.22-aug-300（含自定义插件）
    if [ -f "$Y11_AUG" ]; then
      echo
      echo ">>> 处理 yolo11m-v0.22-aug-300.pt（带自定义 TensorRT-YOLO 插件） ..."
      conda run -n tensorrt trtyolo export -w "$Y11_AUG" -v yolo11 -o "${MODEL_DIR}/" -b 1 -s --iou_thres=0.3 --conf_thres=0.3

      ONNX="${MODEL_DIR}/yolo11m-v0.22-aug-300.onnx"
      ENGINE="${MODEL_DIR}/yolo11m-v0.22-aug-300.engine"

      # 根据模型目录推导插件路径：<模型目录>/../lib/TensorRT-YOLO/lib/plugin/libcustom_plugins.so
      PLUGIN_SO="${MODEL_DIR}/../lib/TensorRT-YOLO/lib/plugin/libcustom_plugins.so"

      if [ -n "$TRTEXEC_PATH" ] && [ -f "$ONNX" ]; then
        if [ -f "$PLUGIN_SO" ]; then
          echo ">>> 使用 trtexec + 自定义插件 转换 yolo11m-v0.22-aug-300.onnx -> yolo11m-v0.22-aug-300.engine ..."
          "$TRTEXEC_PATH" --onnx="$ONNX" --saveEngine="$ENGINE" --fp16 \
            --staticPlugins="$PLUGIN_SO" \
            --setPluginsToSerialize="$PLUGIN_SO"
        else
          echo "警告: 未找到自定义插件库：$PLUGIN_SO"
          echo "将不带插件执行 trtexec（可能导致 OBB 模型不生效），请按需手动调整命令。"
          "$TRTEXEC_PATH" --onnx="$ONNX" --saveEngine="$ENGINE" --fp16
        fi
      fi
    fi

    echo
    echo "模型自动转换流程结束，请检查 ${MODEL_DIR} 中生成的 .onnx 和 .engine 文件。"
  fi

fi



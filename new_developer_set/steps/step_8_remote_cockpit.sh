#!/usr/bin/env bash

#######################################
# 8. 克隆 remote_cockpit 仓库并切换分支
#######################################
step "8. 在 ~/Documents/cockpit_software 克隆 remote_cockpit 仓库并切换到 huiyang_apply 分支"

require_cmd git

GIT_BASE_DIR="$HOME/Documents/cockpit_software"
mkdir -p "$GIT_BASE_DIR"
cd "$GIT_BASE_DIR"

echo
echo "将从 GitHub 克隆仓库：HKCRC/remote_cockpit"
echo "需要一个具有访问权限的 GitHub Token (GITHUB_KEY)，仅用于本次 clone，不会写入任何文件。"
read -rsp "请输入 GITHUB_KEY（输入内容不回显）: " GITHUB_KEY
echo

if [ -z "$GITHUB_KEY" ]; then
  echo "未输入 GITHUB_KEY，跳过仓库克隆和子模块更新。"
else
  REPO_URL="https://${GITHUB_KEY}@github.com/HKCRC/remote_cockpit.git"

  if [ -d "remote_cockpit/.git" ]; then
    echo "检测到已存在的 remote_cockpit 仓库，跳过 clone，直接更新。"
    cd remote_cockpit
    git remote set-url origin "$REPO_URL" || true
    git fetch --all || true
  else
    echo "开始克隆仓库到 ${GIT_BASE_DIR}/remote_cockpit ..."
    git clone "$REPO_URL" remote_cockpit
    cd remote_cockpit
  fi

  echo "切换到分支 huiyang_apply ..."
  git checkout huiyang_apply

  echo "更新子模块 ..."
  git submodule update --init --recursive

  # 清除内存中的 Token 变量
  unset GITHUB_KEY
fi

# 在 cockpit_software 目录下创建 build、models/tensorrt、config 目录
TARGET_BUILD_DIR="${GIT_BASE_DIR}/build"
TARGET_MODELS_TRT_DIR="${GIT_BASE_DIR}/models/tensorrt"
TARGET_CONFIG_DIR="${GIT_BASE_DIR}/config"

mkdir -p "$TARGET_BUILD_DIR" "$TARGET_MODELS_TRT_DIR" "$TARGET_CONFIG_DIR"

echo "已确保存在目录："
echo "  $TARGET_BUILD_DIR"
echo "  $TARGET_MODELS_TRT_DIR"
echo "  $TARGET_CONFIG_DIR"

# 如前面步骤已生成 TensorRT engine 文件，则将其移动到 models/tensorrt 中
if [ -z "${MODEL_DIR:-}" ]; then
  echo "提示: 未检测到上一步的 MODEL_DIR 变量，无法自动移动 engine 文件。"
else
  echo "尝试从 MODEL_DIR (${MODEL_DIR}) 移动 engine 文件到 ${TARGET_MODELS_TRT_DIR} ..."

  for name in yolo11m-p yolo12x-v1.4-nov-300 yolo11m-v0.22-aug-300; do
    SRC="${MODEL_DIR}/${name}.engine"
    if [ -f "$SRC" ]; then
      echo "  移动 $(basename "$SRC") -> ${TARGET_MODELS_TRT_DIR}/"
      mv -f "$SRC" "$TARGET_MODELS_TRT_DIR/"
    else
      echo "  未找到 engine 文件：$SRC，跳过。"
    fi
  done
fi



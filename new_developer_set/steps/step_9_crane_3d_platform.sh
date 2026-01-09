#!/usr/bin/env bash

#######################################
# 9. 运行3D防碰撞系统（crane-3d-platform）
#######################################
step "9. 运行3D防碰撞系统（crane-3d-platform）"

require_cmd git

FRONT_BASE_DIR="$HOME/Documents"
mkdir -p "$FRONT_BASE_DIR"
cd "$FRONT_BASE_DIR"

echo
echo "将从 GitHub 克隆仓库：dubinbin/crane-3d-platform (https://github.com/dubinbin/crane-3d-platform.git)"
echo "同样需要 GitHub Token (GITHUB_KEY)，仅用于本次 clone，不会写入任何文件。"
read -rsp "请输入 GITHUB_KEY（输入内容不回显，留空则使用匿名方式尝试 clone）: " GITHUB_KEY
echo

FRONT_REPO_URL_PUBLIC="https://github.com/dubinbin/crane-3d-platform.git"

if [ -z "$GITHUB_KEY" ]; then
  echo "未输入 GITHUB_KEY，将使用公开地址尝试克隆（若仓库为私有则会失败）。"
  FRONT_REPO_URL="$FRONT_REPO_URL_PUBLIC"
else
  FRONT_REPO_URL="https://${GITHUB_KEY}@github.com/dubinbin/crane-3d-platform.git"
fi

if [ -d "crane-3d-platform/.git" ]; then
  echo "检测到已存在的 crane-3d-platform 仓库，跳过 clone，直接更新。"
  cd crane-3d-platform
  git remote set-url origin "$FRONT_REPO_URL" || true
  git fetch --all || true
else
  echo "开始克隆仓库到 ${FRONT_BASE_DIR}/crane-3d-platform ..."
  git clone "$FRONT_REPO_URL" crane-3d-platform
  cd crane-3d-platform
fi

# 使用用户家目录下的配置路径（默认 /home/<user>/app/public/json/index.json）
CONFIG_PATH_DEFAULT="$HOME/app/public/json/index.json"
CONFIG_PATH="${CONFIG_PATH:-$CONFIG_PATH_DEFAULT}"

echo "检查配置文件是否存在：${CONFIG_PATH}"
if [ -f "$CONFIG_PATH" ]; then
  echo "检测到配置文件存在，开始执行 Docker 启动脚本 ..."
  if [ -x "./docker-start.sh" ]; then
    sudo sh ./docker-start.sh
  else
    echo "警告: 找不到可执行的 docker-start.sh，无法自动启动 Docker。"
  fi
else
  echo "未找到配置文件：${CONFIG_PATH}"
  echo "请确认在路径 ${CONFIG_PATH} 下已生成 index.json，然后手动在仓库目录中执行："
  echo "  sudo sh ./docker-start.sh"
fi



#!/usr/bin/env bash

#######################################
# 1.1 安装 Docker（官方仓库 Installation）
#######################################
step "1.1 安装 Docker（来自 Docker 官方仓库）"

# 1) 添加 Docker 官方 GPG key
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2) 添加 Docker 软件源
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# 3) 安装 Docker 相关软件包（包含 docker-compose 插件）
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# 4) 创建 docker 用户组（如已存在则忽略错误）
sudo groupadd docker 2>/dev/null || true

# 5) 将当前用户加入 docker 组（需要重新登录后生效）
sudo usermod -aG docker "$USER" || true
echo "已将用户 $USER 加入 docker 组，需重新登录或重新打开终端后才能免 sudo 使用 docker。"



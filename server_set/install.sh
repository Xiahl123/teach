#!/bin/bash

# Ubuntu 24.04 服务器自动化安装脚本
# 安装: Node.js, npm, Nginx, Docker, Certbot

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为 root 或使用 sudo
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本需要 root 权限。请使用 sudo 运行。"
        exit 1
    fi
}

# 检查 Ubuntu 版本
check_ubuntu_version() {
    if [ ! -f /etc/os-release ]; then
        log_error "无法检测操作系统版本"
        exit 1
    fi
    
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]] || [[ "$VERSION_ID" != "24.04" ]]; then
        log_warn "此脚本专为 Ubuntu 24.04 设计，当前系统: $ID $VERSION_ID"
        read -p "是否继续? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# 更新系统
update_system() {
    log_info "更新系统包列表..."
    apt-get update -y
    log_info "升级系统包..."
    apt-get upgrade -y
    log_info "安装基础工具..."
    apt-get install -y curl wget gnupg lsb-release ca-certificates software-properties-common
}

# 安装 Node.js 和 npm
install_nodejs() {
    log_info "安装 Node.js 和 npm..."
    
    # 使用 NodeSource 仓库安装 LTS 版本
    NODE_VERSION="20"  # 可以改为 18 或 22
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
    apt-get install -y nodejs
    
    # 验证安装
    NODE_VERSION_INSTALLED=$(node --version)
    NPM_VERSION_INSTALLED=$(npm --version)
    log_info "Node.js 版本: $NODE_VERSION_INSTALLED"
    log_info "npm 版本: $NPM_VERSION_INSTALLED"
    
    # 安装常用全局包
    log_info "安装常用 npm 全局包 (pm2, yarn)..."
    npm install -g pm2 yarn || log_warn "全局包安装失败，但可以稍后手动安装"
}

# 安装 Nginx
install_nginx() {
    log_info "安装 Nginx..."
    apt-get install -y nginx
    
    # 启动并启用 Nginx
    systemctl start nginx
    systemctl enable nginx
    
    # 验证安装
    NGINX_VERSION=$(nginx -v 2>&1 | cut -d'/' -f2)
    log_info "Nginx 版本: $NGINX_VERSION"
    log_info "Nginx 已启动并设置为开机自启"
}

# 安装 Docker
install_docker() {
    log_info "安装 Docker..."
    
    # 添加 Docker 官方 GPG 密钥
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    
    # 添加 Docker 仓库
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 安装 Docker
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # 启动并启用 Docker
    systemctl start docker
    systemctl enable docker
    
    # 将当前用户添加到 docker 组（如果存在非 root 用户）
    if [ -n "$SUDO_USER" ]; then
        usermod -aG docker $SUDO_USER
        log_info "已将用户 $SUDO_USER 添加到 docker 组"
        log_warn "用户需要重新登录才能使用 docker 命令（无需 sudo）"
    fi
    
    # 验证安装
    DOCKER_VERSION=$(docker --version)
    DOCKER_COMPOSE_VERSION=$(docker compose version)
    log_info "Docker 版本: $DOCKER_VERSION"
    log_info "Docker Compose 版本: $DOCKER_COMPOSE_VERSION"
}

# 安装 Certbot
install_certbot() {
    log_info "安装 Certbot..."
    
    # 安装 Certbot 和 Nginx 插件
    apt-get install -y certbot python3-certbot-nginx
    
    # 验证安装
    CERTBOT_VERSION=$(certbot --version)
    log_info "$CERTBOT_VERSION"
}

# 配置防火墙（可选）
configure_firewall() {
    log_info "配置防火墙 (UFW)..."
    
    # 检查 UFW 是否安装
    if command -v ufw &> /dev/null; then
        # 允许必要的端口
        ufw allow OpenSSH
        ufw allow 'Nginx Full'
        ufw --force enable
        log_info "防火墙已配置: SSH 和 Nginx (80, 443)"
        log_warn "确保 SSH 访问正常，避免被锁定"
    else
        log_warn "UFW 未安装，跳过防火墙配置"
    fi
}

# 显示安装摘要
show_summary() {
    log_info "========================================="
    log_info "安装完成！"
    log_info "========================================="
    echo
    log_info "已安装的软件:"
    echo "  - Node.js: $(node --version)"
    echo "  - npm: $(npm --version)"
    echo "  - Nginx: $(nginx -v 2>&1 | cut -d'/' -f2)"
    echo "  - Docker: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
    echo "  - Docker Compose: $(docker compose version | cut -d' ' -f4)"
    echo "  - Certbot: $(certbot --version | cut -d' ' -f2)"
    echo
    log_info "后续步骤:"
    echo "  1. 配置 Nginx: /etc/nginx/sites-available/"
    echo "  2. 使用 Certbot 获取 SSL 证书: sudo certbot --nginx -d yourdomain.com"
    echo "  3. 配置 Docker 服务"
    echo "  4. 部署应用（使用 pm2 或 Docker）"
    echo
    if [ -n "$SUDO_USER" ]; then
        log_warn "注意: 用户 $SUDO_USER 需要重新登录才能使用 docker 命令（无需 sudo）"
    fi
    echo
}

# 主函数
main() {
    log_info "开始 Ubuntu 24.04 服务器环境安装..."
    log_info "========================================="
    echo
    
    check_root
    check_ubuntu_version
    update_system
    install_nodejs
    install_nginx
    install_docker
    install_certbot
    configure_firewall
    show_summary
    
    log_info "安装脚本执行完成！"
}

# 运行主函数
main


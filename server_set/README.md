# Ubuntu 24.04 服务器自动化安装脚本

这是一个自动化安装脚本，用于在 Ubuntu 24.04 服务器上安装部署网站和后端服务所需的基础环境。

## 安装内容

- **Node.js** 和 **npm** (LTS 版本 20.x)
- **Nginx** (Web 服务器)
- **Docker** 和 **Docker Compose** (容器化)
- **Certbot** (SSL 证书自动化)

## 使用方法

### 1. 下载脚本

```bash
# 确保脚本有执行权限
chmod +x install.sh
```

### 2. 运行安装脚本

```bash
# 使用 sudo 运行
sudo ./install.sh
```

### 3. 验证安装

安装完成后，可以使用以下命令验证：

```bash
# 检查版本
node --version
npm --version
nginx -v
docker --version
docker compose version
certbot --version

# 检查服务状态
systemctl status nginx
systemctl status docker
```

## 配置说明

### Node.js

- 默认安装 Node.js 20.x LTS 版本
- 全局安装: `pm2` (进程管理器), `yarn` (包管理器)
- 如需更改版本，编辑脚本中的 `NODE_VERSION` 变量（可选值: 18, 20, 22）

### Nginx

- 配置文件位置: `/etc/nginx/`
- 站点配置: `/etc/nginx/sites-available/`
- 启用站点: `/etc/nginx/sites-enabled/`
- 默认已启动并设置为开机自启

### Docker

- 如果使用非 root 用户运行脚本，该用户会被添加到 docker 组
- **重要**: 添加用户到 docker 组后，需要重新登录才能使用 `docker` 命令（无需 sudo）
- Docker Compose 作为插件安装，使用命令: `docker compose` (不是 `docker-compose`)

### Certbot

- 已安装 Nginx 插件
- 使用示例: `sudo certbot --nginx -d example.com -d www.example.com`
- 自动续期已配置

### 防火墙 (UFW)

- 自动配置开放端口:
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)
- 如果未安装 UFW，将跳过此步骤

## 后续配置

### 1. 配置 Nginx 反向代理

创建站点配置文件:

```bash
sudo nano /etc/nginx/sites-available/your-site
```

示例配置:

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

启用配置:

```bash
sudo ln -s /etc/nginx/sites-available/your-site /etc/nginx/sites-enabled/
sudo nginx -t  # 测试配置
sudo systemctl reload nginx
```

### 2. 获取 SSL 证书

```bash
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

### 3. 使用 PM2 部署 Node.js 应用

```bash
# 启动应用
pm2 start app.js --name myapp

# 保存进程列表
pm2 save

# 设置开机自启
pm2 startup
```

### 4. 使用 Docker 部署服务

```bash
# 创建 docker-compose.yml
# 启动服务
docker compose up -d
```

## 注意事项

1. **备份**: 在生产环境使用前，建议备份重要数据
2. **防火墙**: 确保 SSH 访问正常，避免被 UFW 锁定
3. **用户权限**: 如果使用非 root 用户，重新登录后 docker 命令无需 sudo
4. **安全性**: 安装完成后，建议：
   - 配置 SSH 密钥认证
   - 禁用 root 登录
   - 定期更新系统
   - 配置自动安全更新

## 故障排除

### Nginx 无法启动

```bash
sudo nginx -t  # 检查配置语法
sudo systemctl status nginx  # 查看状态
sudo journalctl -u nginx  # 查看日志
```

### Docker 权限问题

```bash
# 确保用户属于 docker 组
groups $USER

# 如果不是，添加用户到组
sudo usermod -aG docker $USER

# 重新登录或使用
newgrp docker
```

### Certbot 证书续期测试

```bash
sudo certbot renew --dry-run
```

## 卸载

如果需要卸载已安装的软件:

```bash
# 卸载 Node.js
sudo apt-get remove nodejs npm

# 卸载 Nginx
sudo apt-get remove nginx
sudo apt-get purge nginx

# 卸载 Docker
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# 卸载 Certbot
sudo apt-get remove certbot python3-certbot-nginx
```

## 许可证

MIT License


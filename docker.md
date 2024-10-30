#docker 安装
1. 更新软件包：sudo apt-get update
2. 下载依赖包：sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
3. 添加密钥：curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
4. 添加docker存储库：sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb\_release -cs) stable"
5. 更新软件包索引：sudo apt-get update
6. 安装docker engine：sudo apt-get install docker-ce docker-ce-cli containerd.io
7. 启动docker服务：sudo systemctl start docker
8. 验证安装是否成功：docker --version
## docker使用技巧
docker每次使用都需要sudo权限，可以使用用户组的方式解决
1. 使用 sudo 命令执行以下命令，将你的用户添加到 docker 组中：sudo usermod -aG docker $USER
2. 刷新组权限：   newgrp docker
## docker操作教程
https://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html
## docker 运行命令，从image生产container
docker container run -it ubuntu:20.04 /bin/bash
## docker操作
* 从image新建docker：docker run -it --name ubuntu:20.04 ubuntu /bin/bash
* 查看正在运行的容器：docker ps
* 查看所有的容器（包括停止的）：docker ps -a
* 停止容器：docker stop <id>
* 删除容器：docker rm -f <id>
* 退出容器：exit,退出的同时停止，exex,退出之后不停止
* 重启已经停止的容器：docker restart <id>
* 进入后台容器：docker attach <id>
## 使用vscode连接ssh
1. docker中安装ssh
apt-get update
apt-get install openssh-server
apt-get install openssh-client
apt-get install ssh
apt-get install vim





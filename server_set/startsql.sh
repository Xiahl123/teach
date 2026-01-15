cat > start_mysql.sh << 'EOF'
#!/bin/bash
echo "=== 启动 MySQL Docker ==="

# 停止并删除可能存在的旧容器
sudo docker stop mysql 2>/dev/null && echo "停止旧容器"
sudo docker rm mysql 2>/dev/null && echo "删除旧容器"

# 启动新容器
echo "启动 MySQL 容器..."
sudo docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=lingju_root \
  -e MYSQL_DATABASE=appdb \
  -p 3306:3306 \
  mysql:8.0

echo "等待启动..."
for i in {1..30}; do
  if sudo docker exec mysql mysql -uroot -p123456 -e "SELECT 1" >/dev/null 2>&1; then
    echo -e "\n✅ MySQL 启动成功！"
    break
  fi
  echo -n "."
  sleep 1
  if [ $i -eq 30 ]; then
    echo -e "\n❌ 启动超时，查看日志："
    sudo docker logs mysql
  fi
done

echo -e "\n连接信息："
echo "  主机: 127.0.0.1 或 localhost"
echo "  端口: 3306"
echo "  用户: root"
echo "  密码: lingju_root"
echo "  数据库: appdb (已创建)"
EOF

chmod +x start_mysql.sh
sudo ./start_mysql.sh
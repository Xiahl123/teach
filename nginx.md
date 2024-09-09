# 安装nginx和nginx-http-flv-module(第三方插件)
## 教程
https://blog.csdn.net/flyawayl/article/details/108218807
https://wxzzz.com/425.html
## flv直播测试地址
http://bilibili.github.io/flv.js/demo/
## 具体操作
nginx下载地址：https://nginx.org/download/（已测试1.25.5）
https://github.com/winshining/nginx-http-flv-module/blob/master/README.CN.md
## 下载好后，将二者解压至同一文件夹，download即可
## 进入nginx解压后的目录，输入：
将插件nginx-http-flv-module配置到nginx中
./configure --prefix=安装目录 --add-module=插件目录
./configure --prefix=/usr/local/nginx  --add-module=/usr/local/nginx/nginx-http-flv-module
## 编译安装
make
sudo make install
## 配置环境变量
sudo ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/
## 测试是否安装成功
nginx -v
##编辑配置文件
###在http版块之前加入，1935表示rtmp端口
rtmp {
    server {
        listen 1935; #Nginx监听的RTMP推流/拉流端口
        application live {
            live on; #当推流时，RTMP路径中的APP（RTMP中一个概念）匹配myapp时，开启直播
            record off; #不记录视频
            gop_cache off;
        }
    }
}
### 在http的server中加入
location /live {
    flv_live on; #当HTTP请求以/live结尾，匹配这儿，这个选项表示开启了flv直播播放功能
    chunked_transfer_encoding  on; #HTTP协议开启Transfer-Encoding: chunked;方式回复
    add_header 'Access-Control-Allow-Origin' '*'; #添加额外的HTTP头,跨越
    add_header 'Access-Control-Allow-Credentials' 'true'; #添加额外的HTTP头
}
## 推流命令
推本地视频：ffmpeg -re -i ~/Videos/xinyang.mp4 -vcodec copy -acodec copy -f flv rtmp://127.0.0.1:1935/live/test
推其他视频流：ffmpeg -re -i rtmp://liteavapp.qcloud.com/live/liteavdemoplayerstreamid -c copy -f flv rtmp://127.0.0.1:1935/live/testv
## 可能发生的错误
### make时可能存在错误：
config文件不存在：这是因为文件位置在受权限限制的文件夹中，移出即可
### 配置文件时
http版块中的80端口可能被占用，修改为其他端口即可，rtmp端口亦然
### nginx: [error] invalid PID number “” in “/run/nginx.pid” 
https://blog.csdn.net/qq_29695701/article/details/110150823
重新加载 conf文件
## 一些操作
###打开nginx服务
sudo nginx -s reload
###关闭nginx服务
sudo nginx -s stop
###编辑conf文件后，需要重新loadconf文件
sudo nginx -c /usr/local/nginx/conf/nginx.conf
sudo nginx -s reload
###检查nginx配置是否成功
sudo nginx -t

### 推流时，对应访问的网址结构
http://服务器ip:http端口/dir?port=配置文件中rtmp端口号&app=rtmp版块的application名称（上如live）&stream=流名称，可以随便，但必须有
http://example.com[:port]/dir?port=xxx&app=appname&stream=streamname
http://192.168.1.2:1935/live?port=85&app=live&stream=testv
### 录屏推流命令
ffmpeg -video_size 1920x1080 -f x11grab -draw_mouse 1 -i :1.0+0,0 -r 20.0 -vcodec libx264 -pix_fmt yuv420p -preset:v ultrafast -f flv rtmp://192.168.1.2:1935/live/testv

ffmpeg -f dshow -i video="screen-capture-recorder" -f dshow -i audio="virtual-audio-capturer" -vcodec libx264 -preset:v ultrafast -pix_fmt yuv420p -acodec aac -f flv rtmp://172.17.178.120/myapp/test

## 3
ffmpeg -video_size 6480x3840 -framerate 20 -f x11grab -i :1.0+0,0 -vcodec libx264 -pix_fmt yuv420p -preset:v ultrafast -acodec acc -f flv rtmp://192.168.1.2:1935/live/testv
## 4
ffmpeg -video_size 6480x3840 -framerate 20 -f x11grab -i :1.0+0,0 -vcodec libx264 -pix_fmt yuv420p -preset:v ultrafast -f flv -flvflags no_duration_filesize rtmp://192.168.1.2:1935/live/testv
## 5
ffmpeg -video_size 1920*1080 -framerate 5 -f x11grab -i :1.0+0,0 -vcodec libx264 -pix_fmt yuv420p -preset:v ultrafast -f flv -bufsize 200000000 -rtbufsize 200000000 -flvflags no_duration_filesize rtmp://192.168.1.2:1935/live/testv


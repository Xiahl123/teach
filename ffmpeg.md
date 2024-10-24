https://ffmpeg.xianwaizhiyin.net/api-ffmpeg/
# ffmpeg学习地址
https://www.cnblogs.com/aqi00/p/18199486
# 推流的两种方式：
1.使用rtsp流服务器mediamtx：https://github.com/bluenviron/mediamtx
该方法无法用于web直播
# 使用方法
下载压缩包，解压后，直接 ./mediamtx 运行即可
运行之后，相关port就会打开，修改port可以在解压文件的yaml文件中修改相应协议的port
## 测试命令
ffmpeg -re -i rtmp://liteavapp.qcloud.com/live/liteavdemoplayerstreamid -c copy -f rtsp rtsp://localhost:8554/mystream
2.使用nginx和flv推流
该方法可以用于web直播
详细查看nginx文件
# 硬件解码
https://www.cnblogs.com/kn-zheng/p/17411539.html
# 原始文档
https://ffmpeg.org/doxygen/trunk/structAVCodecContext.html
# 中文教程
https://ffmpeg.xianwaizhiyin.net/api-ffmpeg/
## 查看支持的編解碼支持,注意區分encode,decode
ffmpeg -codecs
## 查看支持的硬件加速器
ffmpeg -hwaccels
## 查看相關解碼器參數幫助
ffmpeg -h encode=h264_nvenc

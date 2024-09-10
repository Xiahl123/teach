#!/bin/bash
     INRES="6480x3840" # input resolution
     OUTRES="3240x1920" # output resolution
     FPS="20" # target FPS
     GOP="40" # i-frame interval, should be double of FPS,
     GOPMIN="20" # min i-frame interval, should be equal to fps,
     THREADS="2" # max 6
     CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
     QUALITY="ultrafast"  # one of the many FFMPEG preset
     AUDIO_RATE="44100"
     PROBESZ="500M" # specify a size for the ffmpeg tool to assess frames
     STREAM_KEY="$1" # paste the stream key after calling stream_now
     SERVER="live-mia" # twitch server in miami Florida, see https://stream.twitch.tv/ingests/ for list

     ffmpeg -video_size $INRES -r $FPS -f x11grab -i :1.0+0,0 -f flv -vcodec h264_nvenc \
     -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p \
     -s $OUTRES -preset $QUALITY -bufsize $CBR -probesize $PROBESZ \
     -flvflags no_duration_filesize rtmp://192.168.1.2:1935/live/testv

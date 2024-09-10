#!/bin/bash
     INRES="1366x768" # input resolution
     OUTRES="1366x768" # output resolution
     FPS="30" # target FPS
     GOP="60" # i-frame interval, should be double of FPS,
     GOPMIN="30" # min i-frame interval, should be equal to fps,
     THREADS="2" # max 6
     CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
     QUALITY="ultrafast"  # one of the many FFMPEG preset
     AUDIO_RATE="44100"
     PROBESZ="500M" # specify a size for the ffmpeg tool to assess frames
     STREAM_KEY="$1" # paste the stream key after calling stream_now
     SERVER="live-mia" # twitch server in miami Florida, see https://stream.twitch.tv/ingests/ for list

     ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f pulse -i 0 -f flv -ac 2 -ar $AUDIO_RATE \
       -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
       -s $OUTRES -preset $QUALITY -tune film -acodec aac -threads $THREADS -strict normal \
       -bufsize $CBR -probesize $PROBESZ "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"

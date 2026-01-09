#!/usr/bin/env bash

#######################################
# 1. 安装构建 C++ 的必要程序
#######################################
step "1. 安装构建 C++ 的必要程序和常用开发库"

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  build-essential \
  cmake \
  git \
  pkg-config \
  libgtk2.0-dev \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  libv4l-dev \
  libxvidcore-dev \
  libx264-dev \
  libatlas-base-dev \
  libcurl4-openssl-dev \
  gfortran \
  libhdf5-dev \
  libtiff-dev \
  libpng-dev \
  libjpeg-dev \
  libopenexr-dev \
  libtbb-dev \
  python3-dev \
  python3-numpy \
  libxine2-dev \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  libjsoncpp-dev \
  net-tools \
  nodejs \
  npm \
  libcanberra-gtk-module \
  libcanberra-gtk3-module \
  libopenal-dev \

echo "说明: 文档中的 libjasper-dev 和 libdc1394-22-dev 在 Ubuntu 24.04 上可能不可用，本脚本未强行安装。"



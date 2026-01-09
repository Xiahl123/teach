#!/usr/bin/env bash

#######################################
# 4. 安装 Qt5（推荐 5.15.x）
#######################################
step "4. 安装 Qt5 及常用开发组件"

sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  qtcreator \
  qtbase5-dev \
  qtchooser \
  qt5-qmake \
  qtbase5-dev-tools \
  qtmultimedia5-dev \
  qtwebengine5-dev



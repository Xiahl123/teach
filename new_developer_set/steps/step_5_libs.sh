#!/usr/bin/env bash

#######################################
# 5. 安装常用 C++/数学/系统库
#######################################
step "5. 安装 Boost / nlohmann_json / yaml / dlib / OpenSSL / RandR / Xinerama / BLAS / LAPACK / SQLite3"

sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  libboost-all-dev \
  libjsoncpp-dev \
  libyaml-cpp-dev \
  libdlib-dev \
  libssl-dev \
  libxrandr-dev \
  libxinerama-dev \
  libblas-dev \
  liblapack-dev \
  libsqlite3-dev



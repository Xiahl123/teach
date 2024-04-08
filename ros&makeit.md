# ros
## 安装
### 一键安装
>鱼香社区：wget http://fishros.com/install -O fishros
>	chmod 777 fishros
>	./fishros
ros2:foxy
默认使用了：ros2
### 自己安装
<https://www.ncnynl.com/archives/201802/2278.html>
## 卸载ros包
卸载所有
>ros:sudo apt-get purge ros-*　　　卸载所有包
>	sudo apt-get autoremove　　删除依赖，配置
卸载单个包：
>sudo apt remove ros-foxy-*
>sudo apt autoremove
## 验证ros2是否安装成功
运行小乌龟：
>ros2 run turtlesim turtlesim_node
>新开一个终端输入控制乌龟运动
>ros2 run turtlesim turtle_teleop_key
>开一个terminal，运行以下命令，可以看到ROS的图形化界面，展示结点的关系：
>ros2 run rqt_graph rqt_graph
## 安装完成之后需要执行setup.bash中的命令
source /opt/ros/foxy/setup.bash
## moveit debug
error:
CMake Error at CMakeLists.txt:29 (find_package):
  By not providing "Findeigen_stl_containers.cmake" in CMAKE_MODULE_PATH this
  project has asked CMake to find a package configuration file provided by
  "eigen_stl_containers", but CMake did not find one.

  Could not find a package configuration file provided by
  "eigen_stl_containers" with any of the following names:

    eigen_stl_containersConfig.cmake
    eigen_stl_containers-config.cmake

  Add the installation prefix of "eigen_stl_containers" to CMAKE_PREFIX_PATH
  or set "eigen_stl_containers_DIR" to a directory containing one of the
  above files.  If "eigen_stl_containers" provides a separate development
  package or SDK, be sure it has been installed.

解决：
新开一个终端输入：
可以先用这三个命令安装：
>sudo apt-get install ros-melodic-geographic-*
>sudo apt-get install geographiclib-*
>sudo apt-get install libgeographic-*
还有报错再使用下列语句：
sudo apt-get install ros-foxy-octomap-msgs(ros-ros版本-包名）
报错的包名的下划线改为短横线
## moveit使用源码安装失败，改用apt-get安装
***
## 新建ros工作空间
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src



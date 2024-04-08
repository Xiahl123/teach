#ros版本
ros vesion:noetic
##catkin_make:python 失败，因为自动找到anaconda,使用以下命令解决
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3

/home/xiahl/code/cockpit_ubuntu/CMakeLists.txt:43: error: By not providing "Findcatkin.cmake" in CMAKE_MODULE_PATH this project has asked CMake to find a package configuration file provided by "catkin", but CMake did not find one. Could not find a package configuration file provided by "catkin" with any of the following names: catkinConfig.cmake catkin-config.cmake Add the installation prefix of "catkin" to CMAKE_PREFIX_PATH or set "catkin_DIR" to a directory containing one of the above files.  If "catkin" provides a separate development package or SDK, be sure it has been installed.

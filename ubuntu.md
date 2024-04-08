# ubuntu
 创建文件夹： mkdir 文件夹名
 创建文件： touch 文件名（有可能权限不够）
 给文件添加权限 sudo chmod a+rx 文件名
 创建并打开文件： sudo gedit 文件名
 移除文件：sudo rm -rf 文件名（-r表示递归，f表示强制删除）
 修改文件名：sudo rm 旧名 新名（没有权限时，不能删除，需要-f））
 修改文件夹名：sudo rm 旧名/ 新名/
 快速启动：ALT+F2，输入软件名
***
## 安装包管理
安装新的包：sudo apt install ***
安装新的包：sudo apt-get install ***（-get会自动安装软件包需要的依赖包）
升级软件包：sudo apt upgrade
## 安装.run文件
chmod +x ***.run
./***.run
### 安装dep
sudo dpkg -i ***.deb 

## 卸载
apt --fix-broken install
### 安装设置图标的文件AppImage application bundle 
直接运行即可：./****
***
## 获取root权限
sudo -s
***
## 修改文件权限
 给文件添加管理员权限：chmod 777 文件夹名
>chmod 777 * -R(全部子目录及文件权限改为 777)
>sudo chmod 600 ××× （只有所有者有读和写的权限）
>sudo chmod 644 ××× （所有者有读和写的权限，组用户只有读的权限）
>sudo chmod 700 ××× （只有所有者有读和写以及执行的权限）
>sudo chmod 666 ××× （每个人都有读和写的权限）
>sudo chmod 777 ××× （每个人都有读和写以及执行的权限）
***
## 添加到环境变量
source ***/setup.bash (临时添加到环境变量中，每次都需要添加)
sudo gedit ~/.bashrc(打开path配置文件，永久添加)
修改完后需要：source ~/.bashrc
### 将 ros 环境加入到当前控制台的环境变量
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
***
## cmake安装最新版，apt-get安装的不是最新版
<https://zhuanlan.zhihu.com/p/519732843>
## 读取文件中的命令
source filename

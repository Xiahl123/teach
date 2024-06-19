# js代码加密
    JavaScript Obfuscator
## JavaScript Obfuscator混淆
### 下载安装
    npm install javascript-obfuscator -g
### 测试安装
    javascript-obfuscator -v
## 混淆js文件,默认混淆方式
### 混淆单个文件
    javascript-obfuscator input_file.js
### 批量混淆,使用递归混淆所有文件,该命令在源文件基础上进行修改
    javascript-obfuscator ./ --output ./
### 批量混淆,使用递归,该命令拷贝源文件进行修改
    javascript-obfuscator ./
### 指定输出文件名
    --output a.js
### 指定输出目录
    --output ./output
## 混淆,自定义混淆方式
    参考链接:https://juejin.cn/post/7159874461104570382
# js代码封装
    rollup
## rollup安装
    npm install --global rollup
### 测试安装
    rollup -v
### 找不到rollup
    将rollup设置为环境变量
    rollup路径:D:\nodePack\node_global
    也可以cd到D:\nodePack\node_global路径之后,运行rollup
## rollup使用
    参考链接:https://www.rollupjs.com/tutorial/

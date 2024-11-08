# 软件包名:
com.hkcrc.towercrane(ios和android相同)
# 证书
账号:software@hkcrc.hk
密码:Joh48194
## ios证书

### ios SKU(APP专有id)
towercrane
### apple id

### ios上传

## android证书
建立时间:2024.6.3
keystore文件路径:E:\apk-jks\android\inclinometer.jks
别名:hkcrcinclinometer
密码:INCLINOMETER
有效时长:36500天
查看相关信息命令:cd 到keystore文件,输入keytool -list -v -keystore inclinometer.keystore
### 自动签名
https://docs.flutter.cn/deployment/android
### 查看apk安装文件签名信息
keytool -list -printcert -jarfile wechat.apk
### 手动签名(该方法有问题)
jarsigner -verbose -keystore E:\xxx\test.keystore  -signedjar
 xxxx签名后的xxx.apk D:\xxx\未签名的xxx.apk  testalias
 
 如果jarsigner找不到路径:cd 到jarsigner路径:C:\Program Files\Java\jdk-1.8\bin,再运行上述命令



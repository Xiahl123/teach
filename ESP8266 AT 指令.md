#设置为服务器
AT                      测试指令是否正常
AT+CWMODE=2             设置为AP模式
AT+CIPMUX=1             0：单路连接模式 1：多路连接模式
AT+CWSAP="123","123",5,3   设置AP的SSID和密码
    <ssid>：字符串参数，接入点名称

    <pwd>：字符串参数，密码，范围：8 ~ 63 字节 ASCII

    <channel>：信道号

    <ecn>：加密方式，不支持 WEP

    0: OPEN

    2: WPA_PSK

    3: WPA2_PSK

    4: WPA_WPA2_PSK

AT+CIPSERVER=1,8080     启动TCP服务器，端口为8080
AT+CIPSTO=0             设置服务器永不超时
AT+CIFSR                查看IP地址
AT+CWLIF                查询连接信息
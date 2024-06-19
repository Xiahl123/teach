# http请求可以携带数据至服务端
http请求有两种基本方法,二者的基础就是TCP/IP连接
## GET
get方法将请求数据拼接到url中,不安全,会保留在浏览器记录中,参数有长度限制
get方法没有请求体body,请求消息使用&拼接在url之后
## POST
post方法更安全,参数没有长度限制
post有请求体body
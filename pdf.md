# pdf文件结构:https://zxyle.github.io/PDF-Explained/chapter3.html
## pdf按顺序包含四部分
header，提供PDF版本号
body 包含页面，图形内容和大部分辅助信息的主体，全部编码为一系列对象。
交叉引用表，列出文件中每个对象的位置便于随机访问。
trailer包括trailer字典，它有助于找到文件的每个部分， 并列出可以在不处理整个文件的情况下读取的各种元数据

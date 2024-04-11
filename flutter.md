# flutter 安装环境
	sdk path:/home/xiahl/snap/flutter/common/flutter
## Dart环境,配置flutter环境后，自动配置dart环境
## flutter更新，dart会自动匹配版本更新
	flutter upgrade   
# 控件
## 填充使用padding
## 预设空间大小使用
### SizedbBoxz(不自带背景设置)
### Container(自带背景设置)
## 添加点击事件 GestureDetector
## List view循环：
'
        ListView.builder(
          scrollDirection: Axis.vertical,//指定列表滚动方向,必须有
          shrinkWrap: true,//在主轴方向占用尽可能多的空间,必须设置,不然需要设定高度
          itemCount: myArea.length,
          itemExtent: 52*heightFactor,
          padding:EdgeInsets.only(top:4*widthFactor),
          physics:const NeverScrollableScrollPhysics(),//禁止滑动
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: padWidth*heightFactor),
              child: GestureDetector(
                onTap:()=>exchangeArea(context,index),
                child:buildAreaText(index),
              ),
            );
          },
        ),
      '  
## 返回空widget SizedBox.shrink()
## 访问父类的变量使用：widget.(父类变量名)
## 添加边框线,使用Container组件：  

## Container组合使用：
### 设置大小：
'
	width: 97*widthFactor,
        height: 578*heightFactor,
'
### 绘制背景(包括：边框线，背景色，等)
'
decoration: BoxDecoration(//背景装饰选项
	border:Border.all(
	  color: const Color(0x3D7E868E),
	  width: 1,
	),
	borderRadius:BorderRadius.circular(8),
	color: const Color(0xFFFFFFFF),
	),
'
### 绘制前景(在child上绘制)：foregroundDecoration
### 设定child的对齐方式：alignment
### 设置margin,margin会将前景，背景及child全部排除在外，相当于独立的widget，不属于Container的大小限制
### 设置padding,padding属于Container,收到Container的限制,与margin一样，都使用'EdgeInsets.only(left: padDataFront*widthFactor,right: padDataBack*widthFactor)',描述
## Text：
'  
Text(mLocal,style: const TextStyle(fontSize: 16.0, color: Color(0xFF3D3D3D)),textAlign: TextAlign.center,),
'
### style属性：fontsize(字体大小，pt),color(文字颜色),fontWeight: FontWeight.bold(文字加粗)
### textAlign(文字对齐，指横向对齐方式)
## Divider分割线
'  
const Divider(height: 1.0,color: Color(0x3D7E868E),),
'
## 给界面赋予名称:
'Navigator.push(
        context, MaterialPageRoute(settings: const RouteSettings(name: '/main'),builder: (context)=>Acceptance(projectAbstract: myAbstract[index],)),
    );  
'   
### 该方法会给进入的页面赋予名称,即Acceptance == '/main'
# 修改andorid目录下的gradle文件
## 修改gradle文件，添加的内容需要放在pluginManagement {}和plugins {}块之后


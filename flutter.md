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
### 设置padding,padding属于Container,收到Container的限制,与margin一样，都使用
'EdgeInsets.only(left: padDataFront*widthFactor,right: padDataBack*widthFactor)',描述
## Text：
'  
Text(mLocal,style: const TextStyle(fontSize: 16.0, color: Color(0xFF3D3D3D)),textAlign: TextAlign.center,),
'
### style属性：
fontsize(字体大小，pt),color(文字颜色),fontWeight: FontWeight.bold(文字加粗)
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
## Scrollbar(显示滑动的进度条)  
## 国际化文件生成命令:
flutter gen-l10n  
## 点击输入框,弹出键盘后,提示超出界面距离
在scaffold的属性resizeToAvoidBottomInset设置为false即可阻止页面内容随键盘弹出而滚动.
resizeToAvoidBottomInset: false,

### 该方法会给进入的页面赋予名称,即Acceptance == '/main'
### 获取本地语言
 WidgetsBinding.instance.platformDispatcher.locale
### 监听数据变化,重构
ValueListenableBuilder(
              valueListenable: mActivateAreaChange,
              builder: (BuildContext context, value, Widget? child) {
                return buildMeasureItem(fContext,index);
              },
            ),
# 修改andorid目录下的gradle文件
修改gradle文件，添加的内容需要放在pluginManagement {}和plugins {}块之后
# 文件生成路径
## android
手机自带存储(该部分内存不会被卸载):getFilesDir();
手机内存(该部分可能被卸载):getExternalStorageDirectory()函数:'/storage/emulated/0/Android/data/com.example.inclinometer_flutter/files'
## 数据绑定
### 单项绑定,及回调
定义:final ValueChanged<double> fChange;
申请回调:widget.fChange.call(mValue);
### 双向绑定,仅能传输String类型
定义:final TextEditingController fControl;
外部修改目标类的值:mAngle2SlopeControl.text = '$slopeWarnValue';
内部监听改变:
mControl.addListener(() {
      setState(() {
        mValue = double.parse(mControl.text);
      });
    });




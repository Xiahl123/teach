# flutter 安装环境
	  sdk path:/home/xiahl/snap/flutter/common/flutter
## 设置macos flutter环境
    打开vim ~/.zshrc文件,输入:export PATH='当前路径'/flutter/bin:$PATH
    source .zshrc
## ubuntu
	/home/xiahl/snap/flutter/common/flutter/bin/cache/dart-sdk
## Dart环境,配置flutter环境后，自动配置dart环境
## flutter更新，dart会自动匹配版本更新
	  flutter upgrade   
# flutter的多线程
  flutter中的代码是按顺序执行(同步),一个flutter线程有三个队列,优先级为,main>microtask>event,
    flutter是同步执行,异步执行需要使用以下方式:
    1.Future async/await
      这种方式与android不同,它是把await的部分放到空闲时执行,没有启动多线程执行
      处于不阻塞主线程的考虑,这种方式将代码放到event队列中等待执行
    2.ioslate.spawn
      这种方式是开启多线程执行,但是这种方式不共享数据,数据需要进行线程传输
      使用receiveport进行通信,可以将父子线程中的receiveport的sendport发送给对方以实现双向通信
      在使用完毕receiveport之后,使用receiveport.close()关闭通信通道
      子线程的生命周期:
      暂停:isolate.pause(isolate.pauseCapability)
      恢复:isolate.resume(isolate.pauseCapability)
      结束:isolate.kill(isolate.immediate)
    3.Isolate.run 
    4.compute
      这种方式只能执行顶级函数(不存在于任何类中)即static函数(存在于类中),且只能传递一个参数,返回值也只有一个,并且不能连续传值计算,及线程不能长期存在
      _count = await compute(countEven, 1000000000);
# 控件,一些控件简介:https://m3.material.io/components/date-pickers/accessibility
    填充使用:padding: EdgeInsets.only(left:16*widthFactor,right: 16*widthFactor),
## 预设空间大小使用
    SizedbBoxz(不自带背景设置)
    Container(自带背景设置)
## 添加点击事件 GestureDetector
    GestureDetector(
      onTap:()=>goAcceptance(context,index),
      child: buildAbstract(index),
    ),
## List view循环：
    ListView.builder(
      scrollDirection: Axis.vertical,//指定列表滚动方向,必须有
      shrinkWrap: true,//使用子控件的高度来设置listview的高度
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
    )
## 返回空
    widget SizedBox.shrink()
## 访问父类的变量使用：
    widget.(父类变量名) 
## 设置区域大小,背景色,边框线,圆角,填充,间隔,对齐方式等：
    Container(
      width: 343*widthFactor,//大小
      height: 40*heightFactor,
      alignment: Alignment.center,//对齐方式
      decoration: BoxDecoration(
        border:Border.all(//边框
          color: const Color(0x3D7E868E),//边框颜色
          width: 1,//边框宽度
        ),
        borderRadius: BorderRadius.circular(8),//设置圆角属性
        color: const Color(0xFF4090E6),//设置背景色
      ),
      child: Text(S.current.model_spot,style: const TextStyle(color: Colors.white,fontSize: 16),),
    ),
    绘制前景(在child上绘制)：foregroundDecoration
    设置margin,margin会将前景，背景及child全部排除在外，相当于独立的widget，不属于Container的大小限制
    设置padding,padding属于Container,收到Container的限制,与margin一样，都使用'EdgeInsets.only(left: padDataFront*widthFactor,right: padDataBack*widthFactor)',描述
## Text：
    Text(mLocal,style: const TextStyle(fontSize: 16.0, color: Color(0xFF3D3D3D)),textAlign: TextAlign.center,),
    style属性：fontsize(字体大小，pt),color(文字颜色),fontWeight: FontWeight.bold(文字加粗)
    textAlign(文字对齐，指横向对齐方式)
    超出范围省略号:overflow: TextOverflow.ellipsis,
## Divider分割线 
    const Divider(height: 1.0,color: Color(0x3D7E868E),),
## expanded出错
    flutter中expanded组件需要以flex\row\column为父组件
## 在已有组件上绘制,堆叠布局
    Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAddWarnItem(S.current.device_degree,angleWarnValue,0.1,1.0,0,changeAngle,mAngleChange),
            buildAddWarnItem(S.current.device_poDisplay,slopeWarnValue,1,10,0,changeSlope,mSlopeChange),
          ],
        ),
        Positioned(
          left:6*widthFactor,
          child: Transform.rotate(
            angle: 1.57,
            child: const Icon(MyIcon.linked,color:Color(0xFFB4B3B3),size: 20,),
          ),
        ),
      ],
    ),
## show,弹出新的界面有以下方式(https://www.cnblogs.com/mengqd/p/12526884.html):
    1.showDialog:弹出Material风格对话框,return主要返回AlterDialog,SimpleDialog, 也可以返回自定义界面(widget即可)
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                ...
              );
            }
        );
    2.showCuperinoDialog: 用于弹出ios风格对话框
        showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
          ...
          );
        });
    3.showGeneralDialog:自定义提示框,上述两种提示框由该函数实现
        showGeneralDialog(
        context: context,
        barrierDismissible:true,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: Container(
              height: 300,
              width: 250,
              color: Colors.lightGreenAccent,
            ),
          );
        });
    4.showAboutDialog:用于描述当前App信息，底部提供2个按钮：查看许可按钮和关闭按钮。AboutDialog需要和showAboutDialog配合使用，
        showAboutDialog(
      context: context,
      applicationIcon: Image.asset(
        'images/bird.png',
        height: 100,
        width: 100,
      ),
      applicationName: '应用程序',
      applicationVersion: '1.0.0',
      applicationLegalese: 'copyright 老孟，一枚有态度的程序员',
      children: <Widget>[
        Container(
          height: 30,
          color: Colors.red,
        ),
        Container(
          height: 30,
          color: Colors.blue,
        ),
        Container(
          height: 30,
          color: Colors.green,
        )
      ],
    );
    5.showLicensePage:用于描述当前App许可信息，LicensePage需要和showLicensePage配合使用
    6.showBottomSheet:在最近的Scaffold父组件上展示一个material风格的bottom sheet
        showBottomSheet(
          context: context,
          builder: (context) {
            return Container(height: 200, color: Colors.lightBlue);
          });
    7.showModalBottomSheet:底部弹出，通常和BottomSheet配合使用
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return BottomSheet(...);
            });
    8.showCupertinoModalPopup:展示ios的风格弹出框，通常情况下和CupertinoActionSheet配合使用
    9.showMeau:弹出一个Menu菜单
    10.showSearch:直接跳转到搜索页面
### 弹出界面随着键盘移动的方法:
    使用:Scaffold作为基础widget;Scaffold->Center->SingleChildScrollView->界面组织
    Scaffold需要设置为透明界面:backgroundColor: Colors.transparent,
### 界面不随键盘移动方法
    修改Scaffold属性:resizeToAvoidBottomInset: false,
## dialog种类有以下几种
    1.AlertDialog:这个是android样式的 AlertDialog
    2.SimpleDialog:这个是在屏幕中间显示，可选项列表的一个弹窗，
    3.ShowModalBottomSheet:弹出底部面板,相当于弹出了一个新页面
    4.CupertinoAlertDialog:这个是苹果样式的 AlertDialog
    5.CupertinoActionSheet:苹果式样的底部弹出选择框
### dialog,弹出界面好用的库(弹出简单的消息,弹出loading提示,弹出对话框等,可以从各个方向弹出,能屏蔽点击背景关闭,):
    flutter_smart_dialog
    演示及代码示例:https://xdd666t.github.io/flutter_use/web/index.html#/smartDialog
## TextButton
    TextButton会自动空出左右两边一定距离,使用时需要注意
## 构建监听重构
    ValueNotifier<int> mActivateAreaChange = ValueNotifier<int>(0);//定义监听回调
### 使能重构
    mActivateAreaChange.value值改变即可,如:mActivateAreaChange.value++
### 部署监听重构位置
    ValueListenableBuilder(
      valueListenable: mActivateAreaChange,
      builder: (BuildContext context, value, Widget? child) {
        return buildAreaText(index);
      },
    ),
## 保留小数点位数
    double price = 100 / 3;
    //保留小数点后2位数，并返回字符串：33.33。
    price.toStringAsFixed(2);
    //保留小数点后5位数，并返回一个字符串 33.33333。
    price.toStringAsFixed(5);
## 数据转换
### double--int
    double price = 100 / 3;
    //舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
    price.truncate();
    //舍弃当前变量的小数部分，浮点数形式表示，结果为 33.0。返回值为 double。
    price.truncateToDouble();
    //舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
    price.toInt();
    //小数部分向上进位，结果为 34。返回值为 int 类型。
    price.ceil();
    //小数部分向上进位，结果为 34.0。返回值为 double。
    price.ceilToDouble();
    //当前变量四舍五入后取整，结果为 33。返回值为 int 类型。
    price.round();
    //当前变量四舍五入后取整，结果为 33.0。返回值为 double 类型。
    price.roundToDouble();
## string判断是否为空isEmpty
  isEmpty仅用于判断内容为空'',不能判断是否为null(未初始化)
## 隐藏和显示数据:Visibility
  Visibility(
    visible: mWarn.value,//bool
    child: ,
  );
## 对于Expanded后,无法展开并报错的问题
  应该在Expanded的外层添加一层Expanded,相当于给内部Expanded一个参考高度(就是剩下的高度)
  Expanded->Container->Expanded
# 逻辑交互
## 全局路由以及全局toast
    使用全局context达到全局路由及全局toast的目的
      1.首先建立一个管理全局context的类:
        class NavigatorProvider {
          final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Rex');

          static final NavigatorProvider _instance = NavigatorProvider._();

          NavigatorProvider._();

          /// 赋值给根布局的 materialApp 上
          /// navigatorKey.currentState.pushName('url') 可直接用于跳转
          static GlobalKey<NavigatorState> get navigatorKey => _instance._navigatorKey;

          /// 可用于 跳转，overlay-insert（toast，loading） 使用
          static BuildContext? get navigatorContext => _instance._navigatorKey.currentState?.context;
        }
       2.在MaterialApp中注册这个全局类,并建立首页的routes(路由)
        navigatorKey: NavigatorProvider.navigatorKey,
        routes: {
          '/':(context)=>const MyHomePage(),
        },
       3.在其他界面文件中使用
        3.1路由操作(NavigatorProvider.navigatorKey.currentState即当前的context):NavigatorProvider.navigatorKey.currentState?.popUntil(ModalRoute.withName('/'));//返回至主页面
        3.2toast操作(NavigatorProvider.navigatorContext!即当前的context):globalDisconnectToast(NavigatorProvider.navigatorContext!);
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
# app国际化 https://blog.csdn.net/qq_27909209/article/details/125927908
    在File->Settings中添加扩展Flutter Intl
    在tools->Flutter Intl中选择初始化intl
    初始化后lib文件夹下会生成generated和l10n文件,l10n中的是不同语言的arb文件,generated中的是编译后的文件dart,可调用
    生成文件后,使用tools->Flutter Intl->add local添加其他语言文件
    在代码中的调用方法:S.of(current).xxxx或者S.of(context).xxxx即可获取对应语言的字符串
# 函数操作
## 函数可选操作
    对于可选参数,定义使用[],在必须参数之后进行定义,并可以设置默认选项:Widget buildTableChildCell(bool fLeft,bool fBottom,String fContent, [Color fColor=const Color(0xFF333333)])
  




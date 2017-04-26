# CrashReport
崩溃日志的封装,oc层面和c++层面的异常崩溃都可以获取到。
此demo是对崩溃信息和异常的封装，可以广泛应用到app或者SDK中，具体的使用信息方法如下：
## 实现的功能
1.收集SDK或者app范围内的崩溃日志；
2.监控SDK或者app内的运行状态，依据堆栈信息；
3.监听各种接口服务调用异常。
## Requirements
 iOS 8.0+
 Xcode 7.3 or above
## Guides
在你需要监听的app或者SDK的开头，添加如下的代码：
//此代码是监听程序的开头，这段代码之后所有的崩溃异常信息都可以被检测到。
//注意：c++层面的异常信息，比如说野指针等异常，真机测试测不出来，只能通过Xcode的模拟器来进行测试。
[HYCrashManager installCrashReportHandler];
## 内容示例

name:NSRangeException
reason:
*** -[__NSArrayM objectAtIndex:]: index 2 beyond bounds [0 .. 1]
callStackSymbols:
0   CoreFoundation                      0x000000018ee991d0 <redacted> + 148
1   libobjc.A.dylib                     0x000000018d8d055c objc_exception_throw + 56
2   CoreFoundation                      0x000000018ed7471c <redacted> + 0
3   yiBao                               0x00000001000e48f0 -[ViewController viewDidLoad] + 532
4   UIKit                               0x0000000194d4e924 <redacted> + 1056
5   UIKit                               0x0000000194d4e4ec <redacted> + 28
6   UIKit                               0x0000000194d54c98 <redacted> + 76
7   UIKit                               0x0000000194d52138 <redacted> + 272
8   UIKit                               0x0000000194dc468c <redacted> + 48
9   UIKit                               0x0000000194fd0cb8 <redacted> + 4068
10  UIKit                               0x0000000194fd6808 <redacted> + 1656
11  UIKit                               0x0000000194feb104 <redacted> + 48
12  UIKit                               0x0000000194fd37ec <redacted> + 168
13  FrontBoardServices                  0x0000000190a6f92c <redacted> + 36
14  FrontBoardServices                  0x0000000190a6f798 <redacted> + 176
15  FrontBoardServices                  0x0000000190a6fb40 <redacted> + 56
16  CoreFoundation                      0x000000018ee46b5c <redacted> + 24
17  CoreFoundation                      0x000000018ee464a4 <redacted> + 524
18  CoreFoundation                      0x000000018ee440a4 <redacted> + 804
19  CoreFoundation                      0x000000018ed722b8 CFRunLoopRunSpecific + 444
20  UIKit                               0x0000000194db97b0 <redacted> + 608
21  UIKit                               0x0000000194db4534 UIApplicationMain + 208
22  yiBao                               0x00000001000f7304 main + 124
23  libdyld.dylib                       0x000000018dd555b8 <redacted> + 4



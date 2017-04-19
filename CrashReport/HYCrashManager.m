//
//  HYCrashManager.m
//  CrashReport
//
//  Created by  huiyuan on 2017/4/19.
//  Copyright © 2017年 张宇超. All rights reserved.
//

#import "HYCrashManager.h"
#include <execinfo.h>
#import "sys/utsname.h"
#import <UIKit/UIKit.h>

@interface HYCrashManager ()

//这个的住要是做用是当异常捕获结束之后，要还原系统的句柄。
@property (nonatomic,assign)NSUncaughtExceptionHandler *tmpHandle;

@end

@implementation HYCrashManager

static int signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
    SIGTERM,
    SIGKILL,
    SIGHUP,
    SIGINT,
    SIGQUIT,
    SIGFPE,
    SIGPIPE
};









+(HYCrashManager *)shareInstance
{
    static HYCrashManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HYCrashManager alloc] init];
    });
    return instance;
}

/*
 1.OC层面。
 2.C++ 层面。
 */
+ (void)installCrashReportHandler
{
    //捕获C++层面的异常(野指针、除零、内存访问异常等) 的错误
    NSInteger count = sizeof(signals)/sizeof(signals[0]);
    for (int i = 0; i < count; ++i) {
        signal(signals[i], HYSignalHandler);
    }
    
    /*
     HandleException 函数指针。如果获取系统的异常捕获句柄不是当前自定义的函数句柄，需要先进行保存。再捕获结束之后重新还原。
     */
    NSUncaughtExceptionHandler *handle = NSGetUncaughtExceptionHandler();
    if(handle != HYHandleException){
        //说明当前APP已经被注册过“未捕获异常句柄事件”。
        [HYCrashManager shareInstance].tmpHandle = handle;
    }
    //注册。我自己的定义的函数指针。
    NSSetUncaughtExceptionHandler(&HYHandleException);
}

// 处理信号类错误的回调函数
void HYSignalHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"信号类错误日志:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    //1.写入本地文件中保存
    [@{@"syserror":mstr} writeToFile:[HYCrashManager applicationDocumentsDirectory] atomically:YES];
    //signal类错误日志。
    if ([HYCrashManager shareInstance].uploadBlock) {
        [HYCrashManager shareInstance].uploadBlock(mstr);
    }
    NSSetUncaughtExceptionHandler([HYCrashManager shareInstance].tmpHandle);
}

//OC层面的异常捕获信息。
void HYHandleException(NSException *exception)
{
    if (!exception){
        return;
    }
    
    NSArray *stackArray = [exception callStackSymbols];   // 异常的堆栈信息
    NSString *reason = [exception reason];                // 出现异常的原因
    NSString *name = [exception name];                    // 异常名称
    
    NSString *appInfos = [HYCrashManager appInfos];
    NSString *syserror = [NSString stringWithFormat:@"\nOC层面的异常错误日志:\n%@异常信息:\n异常名称:%@\n异常原因:%@\n异常的堆栈信息:%@\n",appInfos,name,reason,stackArray];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:syserror forKey:@"syserror"];
    
    //1.写入本地文件中保存
    [dic writeToFile:[HYCrashManager applicationDocumentsDirectory] atomically:YES];
    //2.动态发送
    if ([HYCrashManager shareInstance].uploadBlock) {
        [HYCrashManager shareInstance].uploadBlock(syserror);
    }
    NSSetUncaughtExceptionHandler([HYCrashManager shareInstance].tmpHandle);
}

//获取日志文件存储路径。
+ (NSString *)applicationDocumentsDirectory
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString *appCurVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.txt",appCurName,appCurVersion];
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)appInfos
{
    NSString *time = [HYCrashManager getCurrentSystemTimeString];
    
    NSString *identifierNumber = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //手机序列号
    
    NSString *userPhoneName = [[UIDevice currentDevice] name];
    // 手机名称
    
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    // 设备名称  iOS
    
    NSString *deviceModel = [[UIDevice currentDevice] model];
    // 设备类型 iPhone or iPad e.g.
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    // 系统版本
    
    NSString *localPhoneModel = [[UIDevice currentDevice] localizedModel];
    // 国际化区域名称
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appCurName = [infoDic objectForKey:@"CFBundleDisplayName"];
    // 当前应用名称
    
    NSString *appCurVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    // 当前应用软件版本
    
    NSString *appCurVersionNum = [infoDic objectForKey:@"CFBundleVersion"];
    // 当前应用版本号码
    NSString *appInfoString = [NSString stringWithFormat:@"\n应用信息:\n应用名称:%@\n应用版本号:%@\n应用软件版本:%@\n日志生成时间:%@\n\n设备信息:\n设备序列号:%@\n设备名称:%@\n设备系统:%@\n设备类型:%@\n系统版本:%@\n国际化区域名称:%@\n\n",appCurName,appCurVersionNum,appCurVersion,time,identifierNumber,userPhoneName,deviceName,deviceModel,systemVersion,localPhoneModel];
    
    return appInfoString;
}

+(NSString *)getCurrentSystemTimeString
{
    NSDate * data = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd-HH:mm:ss"];
    NSString * timeString = [formatter stringFromDate:data];
    return timeString;
}

@end

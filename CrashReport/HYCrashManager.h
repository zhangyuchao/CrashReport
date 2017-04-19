//
//  HYCrashManager.h
//  CrashReport
//
//  Created by  huiyuan on 2017/4/19.
//  Copyright © 2017年 张宇超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UploadExceptionBlock)(NSString * msg);

@interface HYCrashManager : NSObject

@property (nonatomic,copy)UploadExceptionBlock uploadBlock;
+ (void)installCrashReportHandler;

@end

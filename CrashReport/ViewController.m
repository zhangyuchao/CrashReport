//
//  ViewController.m
//  CrashReport
//
//  Created by  huiyuan on 2017/4/19.
//  Copyright © 2017年 张宇超. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //此处数组越界,给提供崩溃日志信息
    NSArray *arr = [NSArray arrayWithObjects:@"zhangyc",@"zhangy",@"zhang",@"hh", nil];
    NSLog(@"----%@----",arr[4]);
}


@end

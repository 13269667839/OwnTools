//
//  ZYGlobalDefine.h
//  ownTools
//
//  Created by 张毅 on 15-4-10.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#ifndef ownTools_ZYGlobalDefine_h
#define ownTools_ZYGlobalDefine_h
//<start>

#define SAFESTR(str) str==nil?@"":str

#pragma mark
#pragma mark -- 1像素的线
/*
 a、1Point的线在非Retina屏幕则是一个像素，在Retina屏幕上则可能是2个像素（非6plus）或者3个像素（6plus），取决于系统设备的DPI。
 
 b、所以在非6plus屏幕上1像素我们需要当成 1.0/2 = 0.5 来处理。系统绘制的时候再乘上[UIScreen mainScreen].scale得到像素数去绘制。
 
 c、6plus上则需要1.0/3来处理。如果继续用0.5系统绘制时会有0.5像素的问题，系统会采用“antialiasing(反锯齿)”的技术处理，（详见http://www.cnblogs.com/smileEvday/p/iOS_PixelVsPoint.html）。所以6plus上0.5的线宽（即1.5像素）有时候是1像素有时候是2像素，取决于origin.y的不同。
 
 d、因此，有这样的宏。使用时，将所有0.5的替换成KSINGLELINE_WIDTH即可。
 */
#define KSINGLELINE_WIDTH  1.0f/([UIScreen mainScreen].scale)//1像素线宽的宏。

#pragma mark
#pragma mark -- 文件目录
#define kPathTemp                    NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathSearch                 [kPathDocument stringByAppendingPathComponent:@"Search.plist"]

#define kPathMagazine               [kPathDocument stringByAppendingPathComponent:@"Magazine"]
#define kPathDownloadedMgzs         [kPathMagazine stringByAppendingPathComponent:@"DownloadedMgz.plist"]
#define kPathDownloadURLs           [kPathMagazine stringByAppendingPathComponent:@"DownloadURLs.plist"]
#define kPathOperation              [kPathMagazine stringByAppendingPathComponent:@"Operation.plist"]

#define kPathSplashScreen           [kPathCache stringByAppendingPathComponent:@"splashScreen"]

#pragma mark
#pragma mark -- 屏幕尺寸
#define MAINSCREEN_APPLICATIONFRAME [[UIScreen mainScreen]applicationFrame]
#define MAINSCREEN_BOUNDS [[UIScreen mainScreen]bounds]


#pragma mark -
#pragma mark -- 系统版本
#define IOS7DEVICE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8DEVICE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark -
#pragma mark -- 颜色相关
#define RANDOMCOLOR [UIColor colorWithRed:(arc4random() % 255 )/ 255.0f green:(arc4random() % 255 )/ 255.0f blue:(arc4random() % 255 )/ 255.0f alpha:1]
#define RGBColor(A, B, C)    [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define ZY_COLOR(RED, GREEN, BLUE, ALPHA)	[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA]


#pragma mark -
#pragma mark -- lable的对齐方式
#ifdef NSTextAlignmentCenter // iOS6 and later
#   define kLabelAlignmentCenter    NSTextAlignmentCenter
#   define kLabelAlignmentLeft      NSTextAlignmentLeft
#   define kLabelAlignmentRight     NSTextAlignmentRight
#   define kLabelTruncationTail     NSLineBreakByTruncatingTail
#   define kLabelTruncationMiddle   NSLineBreakByTruncatingMiddle
#else // older versions
#   define kLabelAlignmentCenter    UITextAlignmentCenter
#   define kLabelAlignmentLeft      UITextAlignmentLeft
#   define kLabelAlignmentRight     UITextAlignmentRight
#   define kLabelTruncationTail     UILineBreakModeTailTruncation
#   define kLabelTruncationMiddle   UILineBreakModeMiddleTruncation
#endif

#pragma mark -
#pragma mark -- 输出函数宏
//注销下面一行则 输出全部无效
#define SOUFUNDEBUG
#ifdef SOUFUNDEBUG
#define FL_Log(fmt, ...) NSLog((@"%s," "[lineNum:%d]" fmt) , __FUNCTION__, __LINE__, ##__VA_ARGS__); //带函数名和行数
#define L_Log(fmt, ...)  NSLog((@"===[lineNum:%d]" fmt), __LINE__, ##__VA_ARGS__);  //带行数
#define C_Log(fmt, ...)  NSLog((fmt), ##__VA_ARGS__); //不带函数名和行数
#else
#define FL_Log(fmt, ...);
#define L_Log(fmt, ...);
#define C_Log(fmt, ...);
#endif

#pragma mark -
#pragma mark -- myWeakSelf的定义
#ifdef   __myWeakSelf__
#undef   __myWeakSelf__
#endif
#if !__has_feature(objc_arc)
#define  __myWeakSelf__  __block __typeof(self)myWeakSelf = self;
#else
#define  __myWeakSelf__  __weak __typeof(self)myWeakSelf = self;
#endif

#pragma mark -
#pragma mark -- 黑科技
#define BEGIN {
#define END }
#define VOID (void)
#define INSTANTIATE_METHOD -
#define PRINT_INT(n) printf(#n " = %d\n",n) //打印 i/j 可以看出效果

#pragma mark -
#pragma mark -- 电话判断格式宏
#define VALIDATEPHONE @"\\b(1)[3458][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b|\\b(1)(7)[0678][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b"
//<end>
#endif

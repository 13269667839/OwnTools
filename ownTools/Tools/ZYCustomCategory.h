//
//  ZYCustomCategory.h
//  ownTools
//
//  Created by 张毅 on 15/4/21.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
/*
    各种 系统类的 分类集合 附加了一些实用的功能
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (ZY_UIButton_CallBackBlockSupport)
/**
 * 自己重写的添加 按钮点击事件的方法
 * 这个 按钮需要做的事情 写在方法的 block中即可
 * @param block 按钮需要做的事情的block
 */
-(void)add_zy_p_controlEvents:(UIControlEvents)event antionBlock:(void(^)(UIButton * btn)) block;
/**
 * 默认是 UIControlEventTouchUpInside
 *
 * @param block 按钮需要做的事情的block
 */
-(void)add_zy_p_AntionBlock:(void(^)(UIButton * btn)) block;
@end




@interface NSTimer (ZY_NSTimer_CallBackBlockSupport)
/**
 * 自己重写的timer执行的方法 block中写这个timer需要执行的方法 注意循环引用问题 weakSelf
 */
+(NSTimer *)scheduled_zy_TimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)())block;
@end




@interface NSNotificationCenter (ZY_NSNotificationCenter_CallBackBolckSupport)
/**
 * 自己重写的 通知回调事件 需要 post通知时 object 不为空
 *
 * @param name  通知名称
 * @param block 接到通知后处理方法
 */
-(void)add_zy_notificationName:(NSString *)name callBackBlock:(void (^)(NSNotification *backNoti)) block;
@end

@interface UIView (ZY_UIView_FrameAdjust)
- (CGPoint)origin;
- (void)setOrigin:(CGPoint) point;

- (CGSize)size;
- (void)setSize:(CGSize) size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;
@end

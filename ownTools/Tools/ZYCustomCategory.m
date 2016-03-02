//
//  ZYCustomCategory.m
//  ownTools
//
//  Created by 张毅 on 15/4/21.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import "ZYCustomCategory.h"

@implementation UIButton (ZY_UIButton_CallBackBlockSupport)
static const void *zy_add_buttonActionKey = "zy_add_buttonActionKey";
/**
 * 自己重写的添加 按钮点击事件的方法
 * 这个 按钮需要做的事情 写在方法的 block中即可
 * @param block 按钮需要做的事情的block
 */
-(void)add_zy_p_controlEvents:(UIControlEvents)event antionBlock:(void(^)(UIButton * btn)) block
{
    objc_setAssociatedObject(self,
                             zy_add_buttonActionKey,
                             [block copy],
                             OBJC_ASSOCIATION_COPY);
    
    [self addTarget:self action:@selector(zy_p_buttonClick:) forControlEvents:event];
}

-(void)zy_p_buttonClick:(UIButton *)btn
{
    void (^block)(UIButton *button) = objc_getAssociatedObject(self,
                                                               zy_add_buttonActionKey);
    if (block)
    {
        block(btn);
    }
}

-(void)add_zy_p_AntionBlock:(void(^)(UIButton * btn)) block
{
    [self add_zy_p_controlEvents:UIControlEventTouchUpInside antionBlock:block];
}

@end




@implementation NSTimer (ZY_NSTimer_CallBackBlockSupport)
/**
 * 自己重写的timer执行的方法 block中写这个timer需要执行的方法 注意循环引用问题 weakSelf
 */
+(NSTimer *)scheduled_zy_TimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)())block
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(zy_eoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+(void)zy_eoc_blockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.userInfo;
    if (block)
    {
        block();
    }
}
@end



@implementation NSNotificationCenter (ZY_NSNotificationCenter_CallBackBolckSupport)
/**
 * 自己重写的 通知回调事件 需要 post通知时 object 不为空
 *
 * @param name  通知名称
 * @param block 接到通知后处理方法
 */
-(void)add_zy_notificationName:(NSString *)name callBackBlock:(void (^)(NSNotification *))block
{
    [[NSNotificationCenter defaultCenter]addObserverForName:name object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if (block)
        {
            block(note);
        }
    }];
}
@end


@implementation UIView (ZY_UIView_FrameAdjust)
- (CGPoint) origin {
    return self.frame.origin;
}

- (void) setOrigin:(CGPoint) point {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize) size {
    return self.frame.size;
}

- (void) setSize:(CGSize) size {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat) x {
    return self.frame.origin.x;
}

- (void) setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat) y {
    return self.frame.origin.y;
}
- (void) setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat) height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)tail {
    return self.y + self.height;
}

- (void)setTail:(CGFloat)tail {
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.tail;
}

- (void)setBottom:(CGFloat)bottom {
    [self setTail:bottom];
}

- (CGFloat)right {
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}
@end
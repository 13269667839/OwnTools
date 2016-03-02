//
//  ZYBaseTools.h
//  ownTools
//
//  Created by 张毅 on 15/6/18.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZYCustomCategory.h"
#import "ZYGlobalDefine.h"

#pragma mark - 
#pragma mark - 各种枚举的 定义
typedef NS_ENUM(NSInteger, ZY_ButtonImage_RoundType){
    /**
     * 直角
     */
    RoundNone = 0 ,
    /**
     * 顶圆
     */
    RoundTop,
    /**
     * 左圆
     */
    RoundLeft,
    /**
     * 底圆
     */
    RoundBottom,
    /**
     * 右圆
     */
    RoundRight,
    /**
     * 四角全圆
     */
    RoundAll,
};


#pragma mark -
#pragma mark - 接口部分
@interface ZYBaseTools : NSObject
/**
 * 判断 电话号码格式 是否合法
 *
 * @param phone 电话号码
 */
+ (BOOL)isValidatePhone:(NSString *)phone;

/**
 * 创建一个 自定义的 UIImage
 *
 * @param mSize   图片尺寸
 * @param mRadius 图片圆角弧度
 * @param fColor  图片颜色
 * @param rType   图片圆角方式
 * @param sColor  描边颜色
 * @param slWidth 描边宽度
 *
 * @return 创建的图片
 */
+(UIImage *)createImageForSize:(CGSize)mSize radius:(CGFloat)mRadius fillColor:(UIColor *)fColor roundType:(ZY_ButtonImage_RoundType)rType strokeColor:(UIColor *)sColor strokeLineWidth:(float )slWidth;

/**
 * 通过六位字符串 创建颜色
 *
 * @param stringToConvert 六位 颜色字符串
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

/*
 * 添加Label 背景色为 clearColor
 */
+ (void)addLabelWithRect:(CGRect)rect text:(NSString *)text tag:(NSInteger)tag font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment numberOfLine:(NSInteger)numbers superView:(UIView *)superView;

/*
 * 添加label 自适应大小 并且可以在后边的block中 继续根据这个label的frame 摆放后续label
 */
+ (void)addLabelWithX:(CGFloat)x y:(CGFloat)y maxSize:(CGSize)maxSize text:(NSString *)text tag:(NSInteger)tag font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth alignment:(NSTextAlignment)alignment numberOfLine:(NSInteger)numbers superView:(UIView *)superView nextBlock:(void (^) (CGRect previousFrame, CGFloat nextX , CGFloat nextY))frameBlock;

/*
 * 根据字符串获取字符size
 */
+ (CGSize)getTheSizeForString:(NSString *)string withFont:(UIFont *)font andMaxSize:(CGSize)maxSize;

@end

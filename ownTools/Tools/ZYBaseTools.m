//
//  ZYBaseTools.m
//  ownTools
//
//  Created by 张毅 on 15/6/18.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import "ZYBaseTools.h"

@implementation ZYBaseTools


+(UIImage *)createImageForSize:(CGSize)mSize radius:(CGFloat)mRadius fillColor:(UIColor *)fColor roundType:(ZY_ButtonImage_RoundType)rType strokeColor:(UIColor *)sColor strokeLineWidth:(float )slWidth{
    //mSize         大小
    //mRadius       半径
    //fColor        填充颜色
    //RoundType     圆角类型
    //sColor        线画颜色
    //slWidth       线画宽度
    
    UIColor* epsBackColor = [UIColor clearColor];//图像的背景色清空
    
    CGFloat radius = mRadius*2;//半径
    
    CGSize originsize = CGSizeMake(mSize.width*2, mSize.height*2);//大小
    
    CGRect originRect = CGRectMake(0, 0, originsize.width, originsize.height);//矩形
    
    
    UIGraphicsBeginImageContext(originsize);//开辟图像ImageContext---传大小
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置填充背景色。
    CGContextSetFillColorWithColor(ctx, epsBackColor.CGColor);
    
    //路径构造
    CGMutablePathRef path = CGPathCreateMutable();
    
    //起点
    
    float offset=0;
    if (rType==RoundTop||rType==RoundLeft||rType==RoundAll){
        offset+=radius;
    }
    
    CGPathMoveToPoint(path, NULL, originRect.origin.x, originRect.origin.y + offset);
    
    
    //左线--左下点
    if (rType==RoundAll||rType==RoundLeft||rType==RoundBottom) {
        CGPathAddLineToPoint(path, NULL, originRect.origin.x, originRect.origin.y + originRect.size.height - radius);
        
        //左下圆角--左下圆点
        CGPathAddArc(path, NULL, originRect.origin.x + radius, originRect.origin.y + originRect.size.height - radius,
                     radius, M_PI, M_PI / 2, 1);
    }else{
        CGPathAddLineToPoint(path, NULL, originRect.origin.x, originRect.origin.y + originRect.size.height);
    }
    
    //底线--右下点
    if (rType==RoundAll||rType==RoundBottom||rType==RoundRight){
        CGPathAddLineToPoint(path, NULL, originRect.origin.x +originRect.size.width-radius,
                             originRect.origin.y + originRect.size.height);
        
        //右下圆角--右下圆点
        CGPathAddArc(path, NULL, originRect.origin.x + originRect.size.width - radius,
                     originRect.origin.y + originRect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    }else{
        CGPathAddLineToPoint(path, NULL, originRect.origin.x +originRect.size.width,
                             originRect.origin.y + originRect.size.height);
    }
    
    
    //右线--右上点
    if (rType==RoundAll||rType==RoundTop||rType==RoundRight){
        CGPathAddLineToPoint(path, NULL, originRect.origin.x + originRect.size.width, originRect.origin.y + radius);
        
        //右上圆角--右上圆点
        CGPathAddArc(path, NULL, originRect.origin.x + originRect.size.width - radius, originRect.origin.y + radius,
                     radius, 0.0f, -M_PI / 2, 1);
    }else{
        CGPathAddLineToPoint(path, NULL, originRect.origin.x + originRect.size.width, originRect.origin.y);
    }
    
    
    //上线--左上点
    if (rType==RoundAll||rType==RoundTop||rType==RoundLeft){
        CGPathAddLineToPoint(path, NULL, originRect.origin.x + radius, originRect.origin.y);
        
        //左上圆角--左上圆点
        CGPathAddArc(path, NULL, originRect.origin.x + radius, originRect.origin.y + radius, radius,
                     -M_PI / 2, M_PI, 1);
    }else{
        CGPathAddLineToPoint(path, NULL, originRect.origin.x, originRect.origin.y);
    }
    
    //闭合
    CGPathCloseSubpath(path);
    
    
    
    
    if (fColor) {
        
        [fColor setFill];//填充色设置
        CGContextAddPath(ctx, path);//Context加入Path
        CGContextSaveGState(ctx);
        CGContextFillPath(ctx);//填充颜色
        CGContextRestoreGState(ctx);
    }
    
    if (sColor){
        [sColor setStroke];
        CGContextSetLineWidth(ctx, slWidth*2.0);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextAddPath(ctx, path);//Context加入Path
        CGContextStrokePath(ctx);
    }
    
    
    
    UIImage* desImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGPathRelease(path);
    
    return desImage;
}

//电话号码格式判断方法
+ (BOOL)isValidatePhone:(NSString *)phone
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@" , VALIDATEPHONE] evaluateWithObject:phone];
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //SL_Log(@"%f:::%f:::%f",((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f));
    
    return ZY_COLOR(((float) r / 255.0f),((float) g / 255.0f),((float) b / 255.0f), 1);
}

//添加文字
+ (void)addLabelWithRect:(CGRect)rect text:(NSString *)text tag:(NSInteger)tag font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment numberOfLine:(NSInteger)numbers superView:(UIView *)superView
{
    UILabel * label = (UILabel *)[superView viewWithTag:tag];
    if (!label)
    {
        UILabel * label = [[UILabel alloc] initWithFrame:rect];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:text];
        [label setFont:font];
        [label setTextColor:textColor];
        [label setTextAlignment:alignment];
        [label setNumberOfLines:numbers];
        [label setLineBreakMode:NSLineBreakByTruncatingTail];
        [label setTag:tag];
        [superView addSubview:label];
    }
    else
    {
        [label setFrame:rect];
        [label setTextColor:textColor];
        [label setText:text];
    }
}

/*
 * 添加label 自适应大小 并且可以在后边的block中 继续根据这个label的frame 摆放后续label
 */
+ (void)addLabelWithX:(CGFloat)x y:(CGFloat)y maxSize:(CGSize)maxSize text:(NSString *)text tag:(NSInteger)tag font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth alignment:(NSTextAlignment)alignment numberOfLine:(NSInteger)numbers superView:(UIView *)superView nextBlock:(void (^) (CGRect previousFrame, CGFloat nextX , CGFloat nextY))frameBlock
{
    UILabel * label = (UILabel *)[superView viewWithTag:tag];
    
    CGSize size = [self getTheSizeForString:text withFont:font andMaxSize:maxSize];
    CGRect rect = CGRectMake(x, y, size.width, size.height);
    
    if (!label)
    {
        UILabel * label = [[UILabel alloc] initWithFrame:rect];
        [label setBackgroundColor:backgroundColor];
        [label setText:text];
        [label setFont:font];
        [label setTextColor:textColor];
        [label setTextAlignment:alignment];
        [label setNumberOfLines:numbers];
        [label setLineBreakMode:NSLineBreakByTruncatingTail];
        [label setTag:tag];
        [label.layer setBorderColor:borderColor.CGColor];
        [label.layer setBorderWidth:borderWidth];
        [superView addSubview:label];
    }
    else
    {
        [label setTextColor:textColor];
        [label setFrame:rect];
        [label setText:text];
    }
    
    if (frameBlock) frameBlock(rect,rect.origin.x + rect.size.width ,rect.origin.y + rect.size.height);
}

/*
 * 根据字符串获取字符size
 */
+ (CGSize)getTheSizeForString:(NSString *)string withFont:(UIFont *)font andMaxSize:(CGSize)maxSize
{
    CGSize size = CGSizeZero;
#ifdef __IPHONE_7_0
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:Nil].size;
#else
    size = [string sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return size;
}


@end

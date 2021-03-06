//
//  LLLAttributeLabel.h
//  SouFun
//
//  Created by Qianlong Xu on 14-11-13.
//
//功能：可设置对齐方式的，可加点击事件

#import <UIKit/UIKit.h>

@interface LLLAttributeLabel : UILabel


@property (nonatomic,strong, readonly)NSMutableAttributedString *resultAttributedString; // label 的text Str
/**
 *  设置对齐方式，支持右对齐；
 */
@property (nonatomic, assign) CTTextAlignment ctAligment;

//初始化的时候指定一个属性字符串；
- (instancetype)initWithFrame:(CGRect)frame attributeString:(NSMutableAttributedString *)attrString;

///重置总文本，会清空之前的属性字符串；
- (void)setText:(NSString *)tx TextColor:(UIColor *)col FontSize:(CGFloat)fSize;

///为指定range的文本添加样式；
- (void)addTextColor:(UIColor *)col FontSize:(CGFloat)fontSize range:(NSRange)range;

///为指定的文本添加样式；
- (void)addTextColor:(UIColor *)col FontSize:(CGFloat)fontSize keyString:(NSString *)keyString;

//1.2新增方法

///
/**
 *  通过Block回调点击关键词的事件，str为关键词，idx为第几个关键词
 */
@property (nonatomic,copy) void(^LLLclickedKeyAttributeBlock)(NSString *str,NSUInteger idx);

///
/**
 *  建议在设置完属性后调用；返回实际的Rect；
 */
- (CGRect)resetRectAfterSetAttributeFinished;

///
/**
 *  获取label内容的Size,编写高度自适应的View时会用到；
 */
- (CGSize)getLLLLabelSize;

@end


/*
 
 使用方法：
 
 //宽度一定要指定，高度随意；（调用这个方法会重设高度 resetRectAfterSetAttributeFinished）
 LLLAttributeLabel *lllLabel = [[LLLAttributeLabel alloc]initWithFrame:CGRectMake(0, 20, 320, 0)attributeString:nil];
 
 NSString *keyWord = @"http://www.fang.com";
 NSString *keyword2 = @"int (^myBlock)(int num1, int num2)";
 NSString *totalStr = @"中国人，不怕流血：http://www.fang.com 中文再解释：返回类型 (^Block的名字)(Block的参数) = ^返回类型(Block的参数) { 这里放代码 }，例：int (^myBlock)(int num1, int num2) = ^int(int num1, int num2){return 100";
 
 [lllLabel setText:totalStr TextColor:[UIColor blackColor] FontSize:14];
 [lllLabel addTextColor:[UIColor blueColor] FontSize:14 range:[totalStr rangeOfString:keyWord]];
 [lllLabel addTextColor:[UIColor blueColor] FontSize:14 range:[totalStr rangeOfString:keyword2]];
 
 //回调关键词点击；
 lllLabel.LLLclickedKeyAttributeBlock = ^(NSString *keyStr,NSUInteger idx){
 NSLog(@"-----%@---%ld",keyStr,idx);
 };
 
 [lllLabel resetRectAfterSetAttributeFinished];
 [self.view addSubview:lllLabel];
 
 lllLabel.backgroundColor = [UIColor redColor];
 
 */
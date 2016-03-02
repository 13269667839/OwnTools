//
//  AttributeLabel.h
//  SouFun
//
//  Created by zhangjianwei on 15/9/11.
//
//

typedef void(^clickBlock)();

#import <UIKit/UIKit.h>

//图片的model
@interface CoreTextImageData : NSObject
@property (strong, nonatomic) NSString * name;
@property (nonatomic) int position;
@property (nonatomic,copy)NSDictionary *infoDic;
// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;
@end


@interface SouFunXFAttributeLabel : UILabel
@property (nonatomic,strong, readonly)NSMutableAttributedString *resultAttributedString; // label 的text Str


//初始化的时候指定一个属性字符串；
- (instancetype)initWithFrame:(CGRect)frame attributeString:(NSMutableAttributedString *)attrString;

/*
 功能：添加文本样式
 infoDic:图片的一些基本信息
 [NSDictionary dictionaryWithObjectsAndKeys:@"160",@"height",
 @"300",@"width",
 @"woniu.jpg",@"name",
 @"3",@"position",nil];//第几个字符后添加图片
 */
///为指定range的文本添加样式；
- (void)addTextColor:(UIColor *)col FontSize:(CGFloat)fontSize range:(NSRange)range imageinfoDic:(NSDictionary *)infoDic;

- (void)clickImageWithBlock:(clickBlock )block;

///
/**
 *  通过Block回调点击关键词的事件，str为关键词，idx为第几个关键词
 */
@property (nonatomic,copy) void(^LLLclickedKeyAttributeBlock)(NSString *str,NSUInteger idx);

@end

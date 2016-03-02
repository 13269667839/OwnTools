//
//  hehe.m
//  ownTools
//
//  Created by 张毅 on 15-4-10.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import "hehe.h"
#import "ZYGlobalDefine.h"
@implementation hehe

- (void)refreshDataByHasbeenCell:(NSMutableDictionary*)dic owner:(UIViewController *) parentCtr cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super refreshDataByHasbeenCell:dic owner:parentCtr cellForRowAtIndexPath:indexPath];
    self.contentView.backgroundColor = RANDOMCOLOR;
    
    
    
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 30)];
    la.backgroundColor = RANDOMCOLOR;
    la.text = [NSString stringWithFormat:@"section:%ld row:%ld",(long)indexPath.section,(long)indexPath.row];
    [self.contentView addSubview:la];
}

-(UIColor *)arc4Color
{
    
    CGFloat red = arc4random() % 255;
    CGFloat blue = arc4random() % 255;
    CGFloat green = arc4random() % 255;
    NSLog(@"%f-%f-%f",red,green,blue);
    return [UIColor colorWithRed:red / 255.0 green:green/ 255.0 blue:blue/ 255.0 alpha:1];
}

/**
 * virtual function,must be overrided in subclass;
 *  点击cell的方法
 */
- (void)ZYTableViewTabCell:(ZYTableViewBase*)view forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了");
}

@end

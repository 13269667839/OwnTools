//
//  ZYTableViewCellBase.m
//  ownTools
//
//  Created by 张毅 on 15-4-10.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import "ZYTableViewCellBase.h"

@implementation ZYTableViewCellBase

@synthesize controller;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parames:(NSMutableDictionary*)dic owner:(UIViewController *) parentCtr cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        controller =(id <ZYTableViewDelegate>) parentCtr;
        
        UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
        aView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = aView; //  设置选中后cell的背景颜色
        
    }
    return self;
}
- (void)refreshDataByHasbeenCell:(NSMutableDictionary*)dic owner:(UIViewController *) parentCtr cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    controller =(id <ZYTableViewDelegate>) parentCtr;
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = aView; //  设置选中后cell的背景颜色
    
}

- (void)ZYTableViewTabCell:(ZYTableViewBase*)view forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)layoutSubClassViews
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutSubClassViews];
}


@end

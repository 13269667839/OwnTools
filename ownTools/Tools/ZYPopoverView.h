//
//  ZYPopoverView.h
//
//  Created by 张毅 on 15/6/16.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//  仿写 iPad 中的 UIPopoverController

#import <UIKit/UIKit.h>
#define IOS7DEVICE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


@protocol ZYPopoverViewDelegate <NSObject>

- (void)performZYPopoverViewActionWithIndex:(NSInteger)index;

@end

@interface ZYPopoverView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nameDataSource;
@property (nonatomic, strong) NSMutableArray *imageDataSource;
@property (nonatomic, weak) id<ZYPopoverViewDelegate>delegate;

// 初始化方法
- (id)initWithFrame:(CGRect)frame nameArray:(NSMutableArray *)nameArray imageArray:(NSMutableArray *)imageArray delegate:(id)delegate arrowHeight:(CGFloat)arrowHeight backgroundColor:(UIColor *)backgroundColor separatorColor:(UIColor *)separatorColor alpha:(CGFloat)alpha radius:(CGFloat)radius wordSize:(CGFloat)wordSize;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
@end

/*
 
 NSMutableArray *nameArray = [[NSMutableArray alloc] initWithObjects:@"更换看房顾问", @"房源推荐",nil];
 NSMutableArray *imageArray = nil;
 
 CGRect frame = CGRectMake(180, 64, 140, 40 * nameArray.count);
 if (IOS7DEVICE) {
 frame = CGRectMake(175, 64, 140, 40 * nameArray.count);
 }
 ZYPopoverView *menu = [[ZYPopoverView alloc] initWithFrame:frame
 nameArray:nameArray
 imageArray:imageArray
 delegate:self
 arrowHeight:5
 backgroundColor:[UIColor blackColor]
 separatorColor:[ZYPopoverView colorWithHexString:@"6c6c6c"]
 alpha:0.85f
 radius:3.5f
 wordSize:16.0f];
 //self.selectMenuView = menu;
 //self.selectMenuView.hidden = NO;
 [self.view addSubview:menu];
 
 -(void)performZYPopoverViewActionWithIndex:(NSInteger)index
 {
 NSLog(@"点击第%ld个 条目",(long)index);
 }

 
 */

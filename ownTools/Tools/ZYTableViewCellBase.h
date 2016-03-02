//
//  ZYTableViewCellBase.h
//  ownTools
//
//  Created by 张毅 on 15-4-10.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYTableViewBase.h"

@protocol ZYTableViewCellWatcher
- (void)ZYTableViewTabCell:(ZYTableViewBase*)view forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZYTableViewCellBase : UITableViewCell
@property(nonatomic,weak) id <ZYTableViewDelegate> controller;
/**
 * init tableviewcell with style,identify,and display unit paramers;
 *  初始化cell的方法
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parames:(NSMutableDictionary*)dic owner:(UIViewController *) parentCtr cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)refreshDataByHasbeenCell:(NSMutableDictionary*)dic owner:(UIViewController *) parentCtr cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 * virtual function,must be overrided in subclass;
 *  点击cell的方法
 */
- (void)ZYTableViewTabCell:(ZYTableViewBase*)view forRowAtIndexPath:(NSIndexPath *)indexPath;


/**
 * virtual function,must be overrided in subclass;
 */
//
//- (void)layoutSubClassViews;

@end

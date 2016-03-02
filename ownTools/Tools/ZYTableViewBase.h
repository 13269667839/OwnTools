//
//  ZYTableViewBase.h
//  ownTools
//
//  Created by 张毅 on 15-4-9.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
/*
    封装的一个工具类
    主要用于tableView的创建
    要调用初始化tableView和 tableViewSection的方法后
 
    对每一个section进行设置   ZYTableViewSectionSetting
    再对section中cell的设置  ZYTableViewRowSetting
 */

#import <UIKit/UIKit.h>
#import "ZYGlobalDefine.h"
#import "ZYTableViewSectionsAndRowsSettings.h"

@class ZYTableViewBase;
@protocol ZYTableViewDelegate <NSObject>
@optional
- (void)ZYTableViewDoneDeleteItem:(ZYTableViewBase*)view forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)ZYTableViewCanEditRowAtIndexPath:(ZYTableViewBase*)view forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ZYTableViewTouchRefreshView:(id)sender;
/**
 *  加载更多
 */
- (void)ZYTableViewScrollMoreView;
- (NSArray *)ZYTableViewSectionIndexTitlesForTableView;
- (NSInteger)ZYTableViewSectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

-(void)ZYTableViewScroll:(UIScrollView * )scrollView;
-(void)ZYTableDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end

@interface ZYTableViewBase : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *zyTableView;
@property (nonatomic, weak)id<ZYTableViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray *sectionSettings;//里面装 ZYTableViewSectionSetting
@property (nonatomic, strong) NSMutableArray * cellArray;
@property (nonatomic, strong) UIImageView * refreshView;

/**
 * 初始化 tableView的section 必须调用
 *
 */
+ (void)initZYTableSections:(ZYTableViewBase *)tableView sections:(NSInteger) numSections;

/**
 * 初始化 tableView 推荐调用
 */
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (id)initWithFrame:(CGRect)frame position:(CGRect)inframe style:(UITableViewStyle)style;

- (void)reloadTableView;
- (void)setContentOffsetToTop;//将tableView滚动到头部
- (void)deleteCurRowInTable;
- (void)setTableHeaderView:(UIView *)headerView;
- (void)setTableFooterView:(UIView *)footerView;
- (void)setHiddenTableHeaderView:(BOOL) isHidden;
- (void)setHiddenTableFooterView:(BOOL) isHidden;
- (void)setHiddenRefreshView:(BOOL) isHidden;
- (NSInteger)RowsInSection:(NSInteger)section;

- (void)enterTableEditMode;
- (void)leaveTableEditMode;
@end

@interface UIViewController (push)
- (void)pushVCwithClassName:(NSString *)aClass;
@end



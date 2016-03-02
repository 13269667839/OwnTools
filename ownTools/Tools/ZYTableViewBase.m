//
//  ZYTableViewBase.m
//  ownTools
//
//  Created by 张毅 on 15-4-9.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import "ZYTableViewBase.h"
#import "ZYTableViewCellBase.h"

@interface ZYTableViewBase ()
{
    struct
    {
        
    }_ZYTableViewBase_Flags;
}
@end

@implementation ZYTableViewBase
+ (void)initZYTableSections:(ZYTableViewBase *)tableView sections:(NSInteger) numSections
{
    if (numSections == 0)
    {
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < numSections; i++)
    {
        ZYTableViewSectionSetting *sectionSetting = [[ZYTableViewSectionSetting alloc]init];
        [arr addObject:sectionSetting];
    }
    tableView.sectionSettings = arr;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITableView  *dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:(UITableViewStyle)style];
        
        dataTable.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
        dataTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        dataTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [dataTable setDelegate:self];
        [dataTable setDataSource:self];
        self.zyTableView = dataTable;
        [self addSubview:dataTable];
        
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        self.cellArray= arr;
       
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIImageView *refreshView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,frame.size.width, frame.size.height)];
        [self addSubview:refreshView];
        self.refreshView = refreshView;
        
        if (iPhone5)
        {
            [bgView setImage:[UIImage imageNamed:@"i5detailbackground.png"]];
            [refreshView setImage:[UIImage imageNamed:@"i5detailbackground.png"]];
        }
        else
        {
            [bgView setImage:[UIImage imageNamed:@"detailbackground.png"]];
            [refreshView setImage:[UIImage imageNamed:@"i5detailbackground.png"]];
        }
        
        self.zyTableView.backgroundView = bgView;
        self.refreshView.hidden = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame position:(CGRect)inframe style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITableView  *dataTable = [[UITableView alloc] initWithFrame:inframe style:(UITableViewStyle)style];
        [dataTable setDelegate:self];
        [dataTable setDataSource:self];
        self.zyTableView = dataTable;
        [self addSubview:dataTable];
    }
    return self;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)dealloc
{
    
    _zyTableView.delegate = nil;
    _zyTableView.dataSource = nil;
}

- (BOOL)isHiddenTableHeaderView
{
    return self.zyTableView.tableHeaderView.hidden;
}

- (BOOL)isHiddenTableFooterView
{
    return self.zyTableView.tableFooterView.hidden;
}

- (void)setTableHeaderView:(UIView *)headerView
{
    self.zyTableView.tableHeaderView = headerView;
}

- (void)setHiddenTableHeaderView:(BOOL) isHidden
{
    self.zyTableView.tableHeaderView.hidden = isHidden;
}

- (void)setTableFooterView:(UIView *)footerView
{
    self.zyTableView.tableFooterView = footerView;
}

- (void)setHiddenTableFooterView:(BOOL) isHidden
{
    self.zyTableView.tableFooterView.hidden = isHidden;
}

- (void)setHiddenRefreshView:(BOOL) isHidden
{
    self.refreshView.hidden = isHidden;
}

- (NSInteger)RowsInSection:(NSInteger)section
{
    if ([((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).dataItems count] ==0) {
        return  [((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).rowSettings count];
    }
    return [((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).dataItems count];
}


#pragma mark -
#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.sectionSettings.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).dataItems count] ==0) {
        return  [((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).rowSettings count];
    }
    return [((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).dataItems count];
}

-(NSMutableDictionary *)dataToCellStyle
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ZYTABLEVIEWCELLIDENTIFIER = @"ZYTABLEVIEWCELLIDENTIFIER";
    ZYTableViewCellBase *cell = (ZYTableViewCellBase *)[tableView dequeueReusableCellWithIdentifier:ZYTABLEVIEWCELLIDENTIFIER];
    ZYTableViewSectionSetting *currentSectionSetting = (ZYTableViewSectionSetting *)[self.sectionSettings objectAtIndex:indexPath.section];
    NSString *cellClassName = currentSectionSetting.classNameForCell;
    ZYTableViewRowSetting *currentRowSetting = [currentSectionSetting.rowSettings objectAtIndex:indexPath.row];
    UITableViewCellStyle style = currentRowSetting.style;
    Boolean  iscell = [[[cell class] description] isEqualToString:cellClassName];

    if (cell == nil||!iscell)
    {
        if (currentSectionSetting.dataItems != nil)
        {
            id obj = [currentSectionSetting.dataItems objectAtIndex:indexPath.row];
            NSMutableDictionary * temp = [NSMutableDictionary dictionary];
            if ([obj respondsToSelector:@selector(dataToCellStyle)])
            {
                temp = [obj performSelector:@selector(dataToCellStyle)];
                cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:style
                                                               reuseIdentifier: ZYTABLEVIEWCELLIDENTIFIER
                                                                       parames:temp
                                                                         owner:(UIViewController *)_delegate
                                                         cellForRowAtIndexPath:indexPath];
            }
            else
            {
                cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:style
                                                               reuseIdentifier: ZYTABLEVIEWCELLIDENTIFIER parames:temp owner:(UIViewController *)_delegate cellForRowAtIndexPath:indexPath];
            }
        }
        else
        {
            cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:style
                                                           reuseIdentifier: ZYTABLEVIEWCELLIDENTIFIER parames:currentRowSetting.parDictionary owner:(UIViewController *)_delegate cellForRowAtIndexPath:indexPath];
        }
        
        if (cell != nil)
        {
            [self.cellArray addObject:cell];
        }
        
    }
    else
    {
        for (UIView* uiview in [cell.contentView subviews])
        {
            [uiview removeFromSuperview];
        }
    }

    if (currentSectionSetting.dataItems != nil && currentSectionSetting.dataItems.count > 0)
    {
        id obj = [currentSectionSetting.dataItems objectAtIndex:indexPath.row];
        NSMutableDictionary * temp=nil; //= [NSMutableDictionary dictionary];
        if ([obj respondsToSelector:@selector(dataToCellStyle)])
        {
            temp = [obj performSelector:@selector(dataToCellStyle)];            cell.accessoryType = currentRowSetting.accessoryType;
            cell.selectionStyle = currentRowSetting.selectionStyle;
            [(ZYTableViewCellBase*)cell refreshDataByHasbeenCell:temp owner:(UIViewController *)_delegate cellForRowAtIndexPath:indexPath];
            //amend by lhh
            //                        [temp release];
        }
        else
        {
            cell.accessoryType = currentRowSetting.accessoryType;
            cell.selectionStyle = currentRowSetting.selectionStyle;
            [(ZYTableViewCellBase*)cell refreshDataByHasbeenCell:temp owner:(UIViewController *)_delegate cellForRowAtIndexPath:indexPath];
        }
    }
    else
    {
        cell.accessoryType = currentRowSetting.accessoryType;
        cell.selectionStyle = currentRowSetting.selectionStyle;
        [(ZYTableViewCellBase*)cell refreshDataByHasbeenCell:currentRowSetting.parDictionary owner:(UIViewController *)_delegate cellForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.row >= 19)
    {//判断是否大于20条数据，避免少于20条数据时不停重复加载的情况
        if(([indexPath row] == ([currentSectionSetting.dataItems count]-1)) || ([indexPath row] == ([currentSectionSetting.rowSettings count]-1)))
        {
            if (_delegate && [_delegate respondsToSelector:@selector(ZYTableViewScrollMoreView)])
            {
                [_delegate ZYTableViewScrollMoreView];
            }
        }
    }
   	return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZYTableViewSectionIndexTitlesForTableView)]){
        return [_delegate ZYTableViewSectionIndexTitlesForTableView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZYTableViewSectionForSectionIndexTitle:atIndex:)]){
        return [_delegate ZYTableViewSectionForSectionIndexTitle:title atIndex:index];
    }
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return ((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).viewForHeaderInSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return ((ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:section]).viewForFooterInSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndexPath = indexPath;
    ZYTableViewSectionSetting *item =(ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:indexPath.section];
    ZYTableViewRowSetting *row =(ZYTableViewRowSetting*)[item.rowSettings objectAtIndex:indexPath.row];
    return row.titleForDelete;
}

/*
 - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (!tableView.editing) {
 return UITableViewCellEditingStyleNone;
 } else {
 return UITableViewCellEditingStyleDelete;
 }
 }
 */

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


#pragma mark -
#pragma mark -- UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZYTableViewCanEditRowAtIndexPath:forRowAtIndexPath:)]){
        return [_delegate ZYTableViewCanEditRowAtIndexPath:self forRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath =indexPath;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(ZYTableViewDoneDeleteItem:forRowAtIndexPath:)])
        {
            [_delegate ZYTableViewDoneDeleteItem:self forRowAtIndexPath:indexPath];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYTableViewSectionSetting *section = (ZYTableViewSectionSetting *)[self.sectionSettings objectAtIndex:indexPath.section];
    ZYTableViewRowSetting *row = (ZYTableViewRowSetting *)[section.rowSettings objectAtIndex:indexPath.row];
    CGFloat height = row.rowHeight;
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentIndexPath = indexPath;
    ZYTableViewCellBase *selectedCell=(ZYTableViewCellBase*)[tableView cellForRowAtIndexPath:indexPath];
    if (![((id)selectedCell) conformsToProtocol:@protocol(ZYTableViewCellWatcher)])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if([selectedCell respondsToSelector:@selector(ZYTableViewTabCell:forRowAtIndexPath:)])
    {
        [selectedCell ZYTableViewTabCell:self forRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark --ZYTableViewBase interface function for outside
- (void)enterTableEditMode
{
    [self.zyTableView setEditing:YES animated:YES];
}

- (void)leaveTableEditMode
{
    [self.zyTableView setEditing:NO animated:YES];
}

-(void)deleteCurRowInTable
{
    [self.zyTableView beginUpdates];
    ZYTableViewSectionSetting *section = (ZYTableViewSectionSetting*)[self.sectionSettings objectAtIndex:self.currentIndexPath.section];
    [section.dataItems removeObjectAtIndex:self.currentIndexPath.row];
    [section.rowSettings removeObjectAtIndex:self.currentIndexPath.row];
    [self.zyTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.zyTableView endUpdates];
}

- (void)reloadTableView
{
    [self.zyTableView reloadData];
}

- (void)setContentOffsetToTop
{
    [self.zyTableView setContentOffset:CGPointMake(0,0) animated:NO];
}
//检测tableview 滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZYTableViewScroll:)])
    {
        return [_delegate ZYTableViewScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_delegate && [_delegate respondsToSelector:@selector(ZYTableDidEndDragging:willDecelerate:)])
    {
        return [_delegate ZYTableDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

//-(void)appendTableWithData {
//    int indexSection=0;
//    [self.utilityTableView beginUpdates];
//    for (UtilitiesTableViewSection *section in self.setting.utilitysettings){
//        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
//        for (int ind = [self.utilityTableView numberOfRowsInSection:indexSection]; ind < [section.dataItems count]; ind++) {
//            NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:ind inSection:indexSection];
//            [insertIndexPaths addObject:newPath];
//        }
//        [self.utilityTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
//        indexSection++;
//    }
//   [self.utilityTableView endUpdates];
//}
@end

@implementation UIViewController (push)
- (void)pushVCwithClassName:(NSString *)aClass
{
    UIViewController *vc = [[NSClassFromString(aClass) alloc]init];
    if (vc)
    {
        if ([vc isKindOfClass:[UIViewController class]])
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end

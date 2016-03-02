//
//  ZYTableViewSectionsAndRowsSettings.h
//  ownTools
//
//  Created by 张毅 on 15-4-10.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYTableViewRowSetting : NSObject
@property(nonatomic,assign)CGFloat rowHeight;
@property(nonatomic,assign)UITableViewCellStyle style;
@property(nonatomic,assign)UITableViewCellAccessoryType accessoryType;
@property(nonatomic,assign)UITableViewCellSelectionStyle selectionStyle;
@property(nonatomic,strong)NSString *titleForDelete;
@property(nonatomic,strong)NSMutableDictionary *parDictionary;
@end

@interface ZYTableViewSectionSetting : NSObject
@property(nonatomic,strong)NSString *classNameForCell;
@property(nonatomic,assign)CGFloat  sectionHeaderHeight;
@property(nonatomic,assign)CGFloat  sectionFooterHeight;
@property(nonatomic,strong)UIView * viewForHeaderInSection;
@property(nonatomic,strong)UIView * viewForFooterInSection;
@property(nonatomic,strong)NSMutableArray *dataItems;
@property(nonatomic,strong)NSMutableArray *rowSettings;//里面装 ZYTableViewRowSetting
@end





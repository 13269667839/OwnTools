//
//  ZYTableViewSectionsAndRowsSettings.m
//  ownTools
//
//  Created by 张毅 on 15-4-10.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#import "ZYTableViewSectionsAndRowsSettings.h"


@implementation ZYTableViewRowSetting
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _parDictionary= [NSMutableDictionary dictionary];
    }
    return self;
}
@end

@implementation ZYTableViewSectionSetting
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _rowSettings = [NSMutableArray array];
    }
    return self;
}
@end



//
//  ZYModel.h
//  ownTools
//
//  Created by 张毅 on 15/11/12.
//  Copyright © 2015年 com.soufun. All rights reserved.
/*
    如要使用本model需要将 Bulid Settings 里边的 
    Enable Strict Checking of objc_msgSend Calls 设置为 NO
 
    本model和实现字典 将有值的属性 放入字典中 一般用于网络请求 复杂字典配置
    可以避开 频繁的 key value 操作 但是要将不需要的 属性置为 nil
 
    ZYModel *model = [[ZYModel alloc] init];
    model.name = @"ceshi";
    model.age = @"24";
    model.school = @"SouFun";
    model.height = @"168";
 
    NSMutableDictionary *dic = [model getModelDic];
 */

#import <Foundation/Foundation.h>

@interface ZYModel : NSObject

//属性随意定义
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *age;
@property (nonatomic, copy)NSString *school;
@property (nonatomic, copy)NSString *height;

-(NSMutableDictionary *)getModelDic;

@end

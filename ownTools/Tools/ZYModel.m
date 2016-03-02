
//
//  ZYModel.m
//  ownTools
//
//  Created by 张毅 on 15/11/12.
//  Copyright © 2015年 com.soufun. All rights reserved.
//

#import "ZYModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ZYModel



-(NSMutableDictionary *)getModelDic
{
    NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        //NSLog(@"name: %s",property_getName(property));
        //NSLog(@"attributes: %s",property_getAttributes(property));
        
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        SEL selector = NSSelectorFromString(key);//属性对应的 get方法
        
        id value = objc_msgSend(self,selector);//属性中的值
        
        if (value)//如果value存在 则添加键值对
        {
            [modelDic setValue:value forKey:key];
        }
    }
    
    free(properties);
    
    return modelDic;
}

@end

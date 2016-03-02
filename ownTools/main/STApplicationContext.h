//
//  STApplicationContext.h
//  SouFun
//
//  Created by 张程 on 15/4/22.
//
//  功用：ios7下移除所有的AlertView

#import <Foundation/Foundation.h>

@interface STApplicationContext : NSObject

+ (STApplicationContext *)sharedContext;
/// 目前存在的所有UIAlertView
@property(nonatomic, copy, readonly) NSArray *availableAlertViews;

- (void)dismissAllAlertViews;

@end


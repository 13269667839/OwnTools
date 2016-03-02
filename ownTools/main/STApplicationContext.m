//
//  STApplicationContext.m
//  SouFun
//
//  Created by 张程 on 15/4/22.
//
//  功用：ios7下移除所有的AlertView

#import "STApplicationContext.h"
#import "ZYCustomCategory.h"

@interface UIAlertView (STApplicationContext)


@end

@implementation UIAlertView (STApplicationContext)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(show)), class_getInstanceMethod(self, @selector(st_show)));
}

- (void)st_show {
    STApplicationContext *context = [STApplicationContext sharedContext];
    NSHashTable *hashTable = [context valueForKey:@"_alertViewHashTable"];
    if ([hashTable isKindOfClass:[NSHashTable class]]) {
        [hashTable addObject:self];
    }
    [self st_show];
}

@end

@interface STApplicationContext ()

@end

@implementation STApplicationContext

{
    NSHashTable *_alertViewHashTable;
}

static STApplicationContext *_sharedContext;
+ (STApplicationContext *)sharedContext {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedContext = [[STApplicationContext alloc] init]; });
    return _sharedContext;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _alertViewHashTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (NSArray *)availableAlertViews {
    return [[_alertViewHashTable allObjects] copy];
}

- (void)dismissAllAlertViews {
    if (self.availableAlertViews.count > 0) {
        [self.availableAlertViews enumerateObjectsUsingBlock:^(UIAlertView *obj, NSUInteger idx, BOOL *stop) {
            [obj dismissWithClickedButtonIndex:obj.cancelButtonIndex animated:NO];
        }];
    }
}

@end

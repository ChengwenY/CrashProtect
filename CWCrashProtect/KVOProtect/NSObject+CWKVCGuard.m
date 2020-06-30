//
//  NSObject+CWKVCGuard.m
//  Pods
//
//  Created by Chengwen.Y on 2020/6/29.
//

#import "NSObject+CWKVCGuard.h"
#import "NSObject+CWMethodHook.h"

@implementation NSObject (CWKVCGuard)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleInstanceMethod:[NSObject class] originSEL:@selector(valueForUndefinedKey:) newSEL:@selector(cw_valueForUndefinedKey:)];
        [self swizzleInstanceMethod:[NSObject class] originSEL:@selector(setValue:forUndefinedKey:) newSEL:@selector(cw_setValue:forUndefinedKey:)];
    });
}

- (id)cw_valueForUndefinedKey:(NSString *)key {
    NSLog(@"--类：%@  未找到的key: %@--", NSStringFromClass([self class]), key);
    return nil;
}

- (void)cw_setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"--类：%@  未找到的key: %@--", NSStringFromClass([self class]), key);
}
@end

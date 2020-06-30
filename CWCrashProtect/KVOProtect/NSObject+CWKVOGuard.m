//
//  NSObject+CWKvoGuard.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/28.
//

#import "NSObject+CWKVOGuard.h"
#import "NSObject+CWMethodHook.h"
#import "CWKVODelegate.h"
#import <objc/runtime.h>

@implementation NSObject (CWKVOGuard)
static void *CWKVODefenderKey = &CWKVODefenderKey;
static NSString *const CWKVODefenderValue =  "CW_KVODefenderKey";
static inline BOOL isSystemObject(Class cls) {
    NSString *clsName = NSStringFromClass(cls);
    BOOL systemCls = NO;
    if ([clsName containsString:@"NS"]) {
        systemCls = YES;
        return YES;
    }
    NSBundle bundle = [NSBundle bundleForClass:cls];
    if (bundle == [NSBundle mainBundle]) {
        systemCls = YES;
    } else {
        systemCls = NO;
    }
    
    return systemCls;
}

- (CWKVODelegate *)kvoDelegate
{
    id delegate = objc_getAssociatedObject(self, @selector(kvoDelegate));
    if (!delegate) {
        delegate = [[CWKVODelegate alloc] init];
        [self setKvoDelegate:delegate];
    }
    return delegate;
}

- (void)setKvoDelegate:(CWKVODelegate *)kvoDelegate
{
    objc_setAssociatedObject(self, @selector(kvoDelegate), kvoDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (void)cw_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
               options:(NSKeyValueObservingOptions)options
               context:(void *)context
{
    
    if (!isSystemObject([self class])) {
        objc_setAssociatedObject(self, CWKVODefenderKey, CWKVODefenderValue, OBJC_ASSOCIATION_RETAIN);
        if([self.kvoDelegate addKvoInfoWithObserver:observer
                                        forKeyPath:keyPath
                                           options:options
                                           context:context]) {
            [self cw_addObserver:self.kvoDelegate forKeyPath:keyPath options:options context:context];
        } else {
            //error 重复添加
        }
        
    } else {
        [self cw_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)cw_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if (!isSystemObject(self.class)) {
        if ([self.kvoDelegate removeKvoInfoWithObserver:observer forKeyPath:keyPath])
        {
            [self cw_removeObserver:self.kvoDelegate forKeyPath:keyPath];
        } else {
            // error
        }
        
    } else {
        [self cw_removeObserver:observer forKeyPath:keyPath];
    }
}

- (void)cw_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    if (!isSystemObject(self.class)) {
        if ([self.kvoDelegate removeKvoInfoObserver:observer forKeyPath:keyPath context:context]) {
            [self cw_removeObserver:observer forKeyPath:keyPath context:context];
        } else {
            //error
        }
    } else {
        [self cw_removeObserver:observer forKeyPath:keyPath context:context];
    }
}

- (void)cw_dealloc
{
    if (!isSystemObject(self.class)) {
        NSString *value = objc_getAssociatedObject(self, CWKVODefenderKey);
        if (value == CWKVODefenderValue) {
            NSArray *keyPaths = [self.kvoDelegate getAllKeyPaths];
            if (keyPaths.count > 0) {
                //error
            }
            for (NSString *keyPath in keyPaths) {
                [self cw_removeObserver:self.kvoDelegate forKeyPath:keyPath];
            }
        }
    }
    
    [self cw_dealloc];
}
@end

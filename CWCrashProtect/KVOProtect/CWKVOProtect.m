//
//  CWKVOProtect.m
//  Pods
//
//  Created by Chengwen.Y on 2020/7/2.
//

#import "CWKVOProtect.h"
#import "CWCrashProtectUtils.h"
#import "CWKVODelegate.h"

@interface NSObject (CWKVCGuard)

@end

@implementation NSObject (CWKVCGuard)

+ (void)exchangeMethodInKVC {
    cw_swizzleInstanceMethod([NSObject class], @selector(setValue:forUndefinedKey:), [self class], @selector(cw_setValue:forUndefinedKey:));
    cw_swizzleInstanceMethod([NSObject class], @selector(valueForUndefinedKey:), [self class], @selector(cw_valueForUndefinedKey:));
}

- (void)cw_setValue:(id)value forUndefinedKey:(NSString *)key {
    if (!isSystemObject([self class])) {
        CW_CrashErrorHandler(ECWCrashTypeKVO, @{}, @"[%@ setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key %@", self, key);
    } else {
        [self cw_setValue:value forUndefinedKey:key];
    }
}

- (id)cw_valueForUndefinedKey:(NSString *)key
{
    if (!isSystemObject([self class])) {
        CW_CrashErrorHandler(ECWCrashTypeKVO, @{}, @"[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key %@", self, key);

    } else {
        return [self cw_valueForUndefinedKey:key];
    }
}

@end

@interface NSObject (CWKVOGuard)

@end

@implementation NSObject (CWKVOGuard)
static void *CWKVODefenderKey = &CWKVODefenderKey;
static NSString *const CWKVODefenderValue =  @"CW_KVODefenderKey";

+ (void)exchangeMethodInKVO
{
    cw_swizzleInstanceMethod([NSObject class], @selector(addObserver:forKeyPath:options:context:), [self class], @selector(cw_addObserver:forKeyPath:options:context:));
    cw_swizzleInstanceMethod([NSObject class], @selector(removeObserver:forKeyPath:), [self class], @selector(cw_removeObserver:forKeyPath:));
    cw_swizzleInstanceMethod([NSObject class], @selector(removeObserver:forKeyPath:context:), [self class], @selector(cw_removeObserver:forKeyPath:context:));
    
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
            CW_CrashErrorHandler(ECWCrashTypeKVO, @{}, @"%@ 重复添加  observer: %@ keyPath: %@", self, observer, keyPath);
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
            CW_CrashErrorHandler(ECWCrashTypeKVO, @{}, @"%@ 重复删除  observer: %@ keyPath: %@", self, observer, keyPath);
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
            CW_CrashErrorHandler(ECWCrashTypeKVO, @{}, @" %@ 重复删除observer: %@ keyPath: %@", self, observer, keyPath);
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
                CW_CrashErrorHandler(ECWCrashTypeKVO, @{}, @"%@ 释放，未移除observer: %@",self, keyPaths);
            }
            for (NSString *keyPath in keyPaths) {
                [self cw_removeObserver:self.kvoDelegate forKeyPath:keyPath];
            }
        }
    }
    
    [self cw_dealloc];
}
@end
@implementation CWKVOProtect

+ (void)beginProtectKVO
{
    [NSObject exchangeMethodInKVC];
    [NSObject exchangeMethodInKVO];
}

@end

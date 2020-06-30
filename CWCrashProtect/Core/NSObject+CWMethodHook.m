//
//  NSObject+CWMethodHook.m
//  Pods-CrashProtect
//
//  Created by Chengwen.Y on 2020/6/28.
//

#import "NSObject+CWMethodHook.h"
#import <objc/runtime.h>


@implementation NSObject (CWMethodHook)
+ (void)swizzleInstanceMethod:(Class)cls originSEL:(SEL)originSEL newSEL:(SEL)newSEL
{
    Method originalMethod = class_getInstanceMethod(cls, originSEL);
    Method newMethod = class_getInstanceMethod(cls, newSEL);
    
    BOOL didAddMethod = class_addMethod(cls, originSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, newSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void)swizzleClassMethod:(Class)cls originSEL:(SEL)originSEL newSEL:(SEL)newSEL
{
    Class metaClass = objc_getMetaClass(class_getName(cls));
    Method origMethod = class_getInstanceMethod(metaClass, originSEL);
    Method newMethod = class_getInstanceMethod(metaClass, newSEL);
    
    BOOL didAddMethod = class_addMethod(metaClass, originSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(metaClass, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@end

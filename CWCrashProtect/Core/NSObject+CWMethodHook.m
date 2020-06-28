//
//  NSObject+CWMethodHook.m
//  Pods-CrashProtect
//
//  Created by Chengwen.Y on 2020/6/28.
//

#import "NSObject+CWMethodHook.h"
#import <objc/runtime.h>


@implementation NSObject (CWMethodHook)
+ (void)swizzleMethod:(Class)cls originSEL:(SEL)originSEL newSEL:(SEL)newSEL
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
@end

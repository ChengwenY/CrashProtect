//
//  NSObject+CWSELGuard.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/28.
//

#import "NSObject+CWSELGuard.h"
#import "NSObject+CWMethodHook.h"
#import <objc/runtime.h>

@implementation NSObject (CWSELGuard)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleClassMethod:[NSObject class] originSEL:@selector(forwardingTargetForSelector:) newSEL:@selector(cw_forwardingTargetForClassSelector:)];
        [self swizzleInstanceMethod:[NSObject class] originSEL:@selector(forwardingTargetForSelector:) newSEL:@selector(cw_forwardingTargetForInstanceSelector:)];
        
    });
}

- (id)cw_forwardingTargetForInstanceSelector:(SEL)aSelector
{
    if (![self overrideForwardingInstanceMethods]) {
        NSString *clsname = NSStringFromClass([self class]);
        NSString *sel = NSStringFromSelector(aSelector);
        NSLog(@"-----未实现的方法--%@ -- %@", clsname, sel);
        
        NSString *className = @"CW_CrashHandler";
        Class cls = NSClassFromString(className);
        if (!cls) {
            cls = objc_allocateClassPair([NSObject class], className.UTF8String, 0);
            objc_registerClassPair(cls);
        }
        if (!class_getInstanceMethod(cls, aSelector)) {
            class_addMethod(cls, aSelector, (void *)crashSelector, "@@:");
        }
        return [[cls alloc] init];
    }
    return [self cw_forwardingTargetForInstanceSelector:aSelector];
}

+ (id)cw_forwardingTargetForClassSelector:(SEL)aSelector
{
    if (![self overrideForwardingClassMethods]) {
        NSString *clsname = NSStringFromClass([self class]);
        NSString *sel = NSStringFromSelector(aSelector);
        NSLog(@"-----未实现的类方法--%@ -- %@", clsname, sel);
        
        NSString *className = @"CW_CrashHandler";
        Class cls = NSClassFromString(className);
        if (!cls) {
            cls = objc_allocateClassPair([NSObject class], className.UTF8String, 0);
            objc_registerClassPair(cls);
        }
        if (!class_getInstanceMethod(cls, aSelector)) {
            class_addMethod(object_getClass(cls), aSelector, (void *)crashSelector, "@@:");
        }
        return cls;
    }
    return [self cw_forwardingTargetForClassSelector:aSelector];
}

- (BOOL)overrideForwardingInstanceMethods {
    
    BOOL override = NO;
    SEL forwardingSel = @selector(forwardingTargetForSelector:);
    SEL signatureSEL = @selector(methodSignatureForSelector:);

    Method currentForwardingMethod = class_getInstanceMethod([self class], forwardingSel);
    Method origForwardingMethod = class_getInstanceMethod([NSObject class], forwardingSel);
    
    Method currentMethodSign = class_getInstanceMethod([self class], signatureSEL);
    Method origMethodSign = class_getInstanceMethod([NSObject class], signatureSEL);
    
    override = method_getImplementation(currentForwardingMethod) == method_getImplementation(origForwardingMethod) || method_getImplementation(currentMethodSign) == method_getImplementation(origMethodSign);
    return override;
}

+ (BOOL)overrideForwardingClassMethods {
    BOOL override = NO;
    SEL forwardingSel = @selector(forwardingTargetForSelector:);
    SEL signatureSEL = @selector(methodSignatureForSelector:);
    
    Method currentForwardingMethod = class_getClassMethod([self class], forwardingSel);
    Method origForwardingMethod = class_getClassMethod([NSObject class], forwardingSel);
    
    Method currentMethodSign = class_getClassMethod([self class], signatureSEL);
    Method origMethodSign = class_getClassMethod([NSObject class], signatureSEL);
    
    override = method_getImplementation(currentForwardingMethod) == method_getImplementation(origForwardingMethod) || method_getImplementation(currentMethodSign) == method_getImplementation(origMethodSign);
    return override;
}

static int crashSelector(id self, SEL selector) {
    return 0;
}

@end

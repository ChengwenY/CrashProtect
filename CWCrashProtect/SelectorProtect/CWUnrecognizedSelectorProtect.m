//
//  CWUnrecognizedSelectorProtect.m
//  Pods
//
//  Created by Chengwen.Y on 2020/7/2.
//

#import "CWUnrecognizedSelectorProtect.h"
#import "CWCrashProtectUtils.h"
@interface NSObject (CWSELGuard)

@end
@implementation NSObject (CWSELGuard)

+ (void)exchangeForwardingMethod
{
    cw_swizzleClassMethod([NSObject class], @selector(forwardingTargetForSelector:), [self class], @selector(cw_forwardingTargetForClassSelector:));
    cw_swizzleInstanceMethod([NSObject class], @selector(forwardingTargetForSelector:), [self class], @selector(cw_forwardingTargetForInstanceSelector:));
}

- (id)cw_forwardingTargetForInstanceSelector:(SEL)aSelector
{
    if (![self overrideForwardingInstanceMethods]) {
        NSString *clsname = NSStringFromClass([self class]);
        NSString *sel = NSStringFromSelector(aSelector);
        CW_CrashErrorHandler(ECWCrashTypeUnrecognizedSelector, @{}, @"-[%@ %@]: unrecognized selector sent to instance %@", clsname, sel,self);
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
        CW_CrashErrorHandler(ECWCrashTypeUnrecognizedSelector, @{}, @"-[%@ %@]: unrecognized selector sent to class %@", clsname, sel ,self);
        NSString *className = @"CW_CrashHandler";
        Class cls = NSClassFromString(className);
        if (!cls) {
            cls = objc_allocateClassPair([NSObject class], className.UTF8String, 0);
            objc_registerClassPair(cls);
        }
        if (!class_getClassMethod(cls, aSelector)) {
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
    
    override = method_getImplementation(currentForwardingMethod) != method_getImplementation(origForwardingMethod) || method_getImplementation(currentMethodSign) != method_getImplementation(origMethodSign);
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
    
    override = method_getImplementation(currentForwardingMethod) != method_getImplementation(origForwardingMethod) || method_getImplementation(currentMethodSign) != method_getImplementation(origMethodSign);
    return override;
}

static int crashSelector(id self, SEL selector) {
    return 0;
}

@end

@implementation CWUnrecognizedSelectorProtect

+ (void)beginProtectUnrecognizedSelector
{
    [NSObject exchangeForwardingMethod];
}

@end

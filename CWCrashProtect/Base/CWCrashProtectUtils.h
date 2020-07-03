//
//  CWCrashProtectUtils.h
//  Pods
//
//  Created by Chengwen.Y on 2020/7/1.
//

#import <objc/runtime.h>
#import "CWCrashCatchError.h"
#import "CWCrashErrorHandler.h"

#ifndef CWCrashProtectUtils_h
#define CWCrashProtectUtils_h

#define CW_Assert(condition, ...)\
if (!(condition)) CWLog(__FILE__, __FUNCTION__, __LINE__, __VA_ARGS__); \
//NSAssert(condition, @"%@", __VA_ARGS__);

#define CW_ErrorHandleBlock [CWCrashErrorHandler sharedInstance].errorHandleBlock

#define CW_CrashErrorHandler(type, theUserInfo, fmt, ...) \
NSString *errorDesc = CWErrorDesc(fmt, __VA_ARGS__);\
CWCrashCatchError *error = [[CWCrashCatchError alloc] initWithType:type desc:errorDesc symbols:[NSThread callStackSymbols] userInfo:theUserInfo];\
if (CW_ErrorHandleBlock) {\
    CW_ErrorHandleBlock(error);\
}\

//CW_Assert(NO, errorDesc);\

static inline NSString *CWErrorDesc(NSString *fmt, ...)
{
    va_list args; va_start(args, fmt);
    NSString *s = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    return s;
}
static inline void CWLog(const char* file, const char* func, int line, NSString* fmt, ...)
{
    va_list args; va_start(args, fmt);
    NSLog(@"%s|%s|%d|%@", file, func, line, [[NSString alloc] initWithFormat:fmt arguments:args]);
    va_end(args);
}

static inline BOOL isSystemObject(Class cls) {
    NSString *clsName = NSStringFromClass(cls);
    BOOL systemCls = NO;
    if ([clsName containsString:@"NS"]) {
        systemCls = YES;
        return YES;
    }
    NSBundle *bundle = [NSBundle bundleForClass:cls];
    if (bundle == [NSBundle mainBundle]) {
        systemCls = NO;
    } else {
        systemCls = YES;
    }
    
    return systemCls;
}

static inline void cw_swizzleInstanceMethod(Class cls, SEL originalSEL, Class newCls,SEL newSEL) {
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method newMethod = class_getInstanceMethod(newCls, newSEL);
    
    BOOL didAddMethod = class_addMethod(cls, originalSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, newSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

static inline void cw_swizzleClassMethod(Class cls, SEL originalSEL, Class newCls, SEL newSEL) {
    Method originalMethod = class_getClassMethod(cls, originalSEL);
    Method newMethod = class_getClassMethod(newCls, newSEL);
    
    method_exchangeImplementations(originalMethod, newMethod);
}
#endif /* CWCrashProtectUtils_h */

//
//  NSObject+CWMethodHook.h
//  Pods-CrashProtect
//
//  Created by Chengwen.Y on 2020/6/28.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CWMethodHook)

+ (void)swizzleInstanceMethod:(Class)cls originSEL:(SEL)originSEL newSEL:(SEL)newSEL;
+ (void)swizzleClassMethod:(Class)cls originSEL:(SEL)originSEL newSEL:(SEL)newSEL;
@end

NS_ASSUME_NONNULL_END

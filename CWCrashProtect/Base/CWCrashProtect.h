//
//  CWCrashProtect.h
//  Pods
//
//  Created by Chengwen.Y on 2020/7/1.
//

#import <Foundation/Foundation.h>
#import "CWCrashErrorHandler.h"

typedef NS_OPTIONS(NSInteger, CWCrashProtectType) {
    
    ECWCrashProtectUnrecognizedSelector  = 1,
    ECWCrashProtectKVO                   = 1<<1,
    ECWCrashProtectContainers            = 1<<2,
    
    ECWCrashProtectAll                   = 0xFFFFFF,
};

NS_ASSUME_NONNULL_BEGIN

@interface CWCrashProtect : NSObject

+ (void)openCrashProtect:(CWCrashProtectType)protectType;

+ (void)setErrorHandlerBlock:(CWCrashErrorHandleBlock)block;
@end

NS_ASSUME_NONNULL_END

//
//  CWCrashErrorHandler.h
//  Pods
//
//  Created by Chengwen.Y on 2020/7/2.
//

#import <Foundation/Foundation.h>
#import "CWCrashCatchError.h"

NS_ASSUME_NONNULL_BEGIN
/**
 错误处理block
 */
typedef void(^CWCrashErrorHandleBlock)(CWCrashCatchError *);

@interface CWCrashErrorHandler : NSObject

@property (nonatomic, copy) CWCrashErrorHandleBlock errorHandleBlock;

+ (instancetype)sharedInstance;

- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));

@end

NS_ASSUME_NONNULL_END

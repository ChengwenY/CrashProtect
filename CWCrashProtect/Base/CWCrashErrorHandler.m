//
//  CWCrashErrorHandler.m
//  Pods
//
//  Created by Chengwen.Y on 2020/7/2.
//

#import "CWCrashErrorHandler.h"

@implementation CWCrashErrorHandler

static CWCrashErrorHandler *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (void)setErrorHandleBlock:(CWCrashErrorHandleBlock)errorHandleBlock
{
    _errorHandleBlock = errorHandleBlock;
}

@end

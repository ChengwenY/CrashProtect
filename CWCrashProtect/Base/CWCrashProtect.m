//
//  CWCrashProtect.m
//  Pods
//
//  Created by Chengwen.Y on 2020/7/1.
//

#import "CWCrashProtect.h"
#import "CWContainerProtect.h"
#import "CWKVOProtect.h"
#import "CWUnrecognizedSelectorProtect.h"

@implementation CWCrashProtect

+ (void)openCrashProtect:(CWCrashProtectType)protectType
{
    if (protectType & ECWCrashProtectContainers) {
        [CWContainerProtect beginProtectContainers];
    }
    if (protectType & ECWCrashProtectKVO) {
        [CWKVOProtect beginProtectKVO];
    }
    if (protectType & ECWCrashProtectUnrecognizedSelector) {
        [CWUnrecognizedSelectorProtect beginProtectUnrecognizedSelector];
    }
}

+ (void)setErrorHandlerBlock:(CWCrashErrorHandleBlock)block {
    
    [[CWCrashErrorHandler sharedInstance] setErrorHandleBlock:block];
}

@end

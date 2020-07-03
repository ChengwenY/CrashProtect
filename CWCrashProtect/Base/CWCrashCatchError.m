//
//  CWCrashCatchHandler.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/7/1.
//

#import "CWCrashCatchError.h"

//static NSString * const CWUnrecognizedSelector_class = @"CWUnrecognizedSelector_class";
//static NSString * const CWUnrecognizedSelector_sel = @"CWUnrecognizedSelector_sel";
//
//static NSString * const CWKVO_observer = @"CWKVO_observer";
//static NSString * const CWKVO_ = @"CWKVO_observer";

//static NSString * const CWContainer_

@implementation CWCrashCatchError

- (instancetype)initWithType:(CWCrashType)type desc:(NSString *)desc symbols:(NSArray *)symbols userInfo:(NSDictionary *)userInfo {    self = [super init];
    if (self) {
        self.errorType = type;
        self.userInfo = userInfo;
        self.errorDesc = desc;
        self.callStackSymbols = symbols;
    }
    return self;
}

@end

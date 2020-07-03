//
//  CWCrashCatchHandler.h
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/7/1.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CWCrashType) {
    ECWCrashTypeUnrecognizedSelector,
    ECWCrashTypeKVO,
    ECWCrashTypeContainers,
};

NS_ASSUME_NONNULL_BEGIN

@interface CWCrashCatchError : NSObject

- (instancetype)initWithType:(CWCrashType)type desc:(NSString *)desc symbols:(NSArray *)symbols userInfo:(NSDictionary *)userInfo;

@property (nonatomic, assign) CWCrashType errorType;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, copy) NSString *errorDesc;
@property (nonatomic, strong) NSArray *callStackSymbols;

@end

NS_ASSUME_NONNULL_END

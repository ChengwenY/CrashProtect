//
//  KVOTestVC.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/30.
//  Copyright © 2020 CW. All rights reserved.
//

#import "KVOTestVC.h"
//#import "NSObject+CWKVOGuard.h"
#import "NSObject+CWKVCGuard.h"
@interface TestInfo : NSObject
@property (nonatomic, assign) NSInteger number;
@end
@implementation TestInfo


@end

@interface KVOTestVC ()

@property (nonatomic, strong) TestInfo *testInfo;

@end

@implementation KVOTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TestInfo *info = [[TestInfo alloc] init];
    [info addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:NULL];
    [info addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:NULL];
//    info.number = 2;
    [info setValue:@2 forKey:@"number"];
    
    self.testInfo = [[TestInfo alloc] init];
    [self.testInfo addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:NULL];
//    self.testInfo.number = 2;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqual: @"number"]) {
        NSLog(@"number observer");
    }
}




@end

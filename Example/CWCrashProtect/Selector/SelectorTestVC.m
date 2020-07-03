//
//  SelectorTestVC.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/30.
//  Copyright © 2020 CW. All rights reserved.
//

#import "SelectorTestVC.h"


@interface UnrecognizedTest : NSObject

- (void)test;
+ (void)classMethod;

@end

@implementation UnrecognizedTest


@end

@interface SelectorTestVC ()

@end

@implementation SelectorTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testUnrecognized];
}

- (void)testUnrecognized
{
    UnrecognizedTest *test = [[UnrecognizedTest alloc] init];
    [test test];
    
    [UnrecognizedTest classMethod];
}


@end

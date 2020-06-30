//
//  ContainerTestVC.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/30.
//  Copyright © 2020 CW. All rights reserved.
//

#import "ContainerTestVC.h"
#import "NSArray+CWGuard.h"

@interface ContainerTestVC ()

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation ContainerTestVC

//objectAtIndex
//objectAtIndexedSubscript



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datasource = @[@"objectAtIndex", @"atIndexedSubscript"].mutableCopy;
    
    int y = 100, x = 20, width = (self.view.bounds.size.width- 60)/2 , height = 50;
    NSInteger index = 0;
    for (NSString *title in self.datasource) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setBackgroundColor:[UIColor yellowColor]];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, width, height);
        [btn addTarget:self action:@selector(btnActions:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index++;
        [self.view addSubview:btn];
        BOOL newline = index % 2 == 0;
        x = newline ? 20 : x + btn.frame.size.width + 20;
        y = newline ? y + btn.frame.size.height + 40 : y;
    }
}

- (void)btnActions:(UIButton *)btn
{
    NSInteger index = btn.tag;
    if (index == 0) {
        [self testArrObjectAtIndex];
    } else if (index == 1) {
        [self testArrObjectSubscript];
    }
    
}

- (void)testArrObjectAtIndex {
    NSArray *zeroArr = @[];
    [zeroArr objectAtIndex:0];
    NSArray *singleArr = @[@1];
    [singleArr objectAtIndex:1];
    NSArray *arr = @[@1,@2];
    [arr objectAtIndex:2];
    NSMutableArray *marr = @[@1].mutableCopy;
    [marr objectAtIndex:3];
}

- (void)testArrObjectSubscript {
    NSArray *zeroArr = @[];
    zeroArr[1];
    NSArray *singleArr = @[@1];
    singleArr[2];
    NSArray *arr = @[@1,@2];
    arr[3];
    NSMutableArray *marr = @[@1].mutableCopy;
    marr[4];
}
@end

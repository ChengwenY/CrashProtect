//
//  ViewController.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/6/30.
//  Copyright © 2020 CW. All rights reserved.
//

#import "ViewController.h"
#import "ContainerTestVC.h"
#import "KVOTestVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.dataSource = @[
        @{@"title" : @"集合类崩溃",
            @"vc" : @"ContainerTestVC",
        }, @{@"title" : @"方法未实现",
            @"vc" : @"SelectorTestVC",
        }, @{@"title" : @"KVC/KVO",
            @"vc" : @"KVOTestVC"
        }
    ].mutableCopy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcName = self.dataSource[indexPath.row][@"vc"];
    
    Class vcCls = NSClassFromString(vcName);

    UIViewController *vc = [[vcCls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end

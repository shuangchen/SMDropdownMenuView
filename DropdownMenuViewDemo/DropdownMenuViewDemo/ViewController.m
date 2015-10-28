//
//  ViewController.m
//  DropdownMenuViewDemo
//
//  Created by OrangeLife on 15/10/27.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "ViewController.h"
#import "DropdownMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor brownColor]];
    DropdownMenuView *menuView = [[DropdownMenuView alloc] initWithFrame:CGRectMake(0, 0, 100, 44) titles:@[@"首页",@"朋友圈",@"我的关注",@"明星",@"家人朋友"]];
    [self.navigationItem setTitleView:menuView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

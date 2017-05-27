//
//  ViewController.m
//  WRSegmentedControlDemo
//
//  Created by xianghui on 2017/5/27.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import "ViewController.h"
#import "WRSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WRSegmentedControl *segmentedControl = [[WRSegmentedControl alloc] initWithItems:@[@"x1", @"x2", @"x3"]];
    segmentedControl.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:segmentedControl];
    
    [segmentedControl addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test:(WRSegmentedControl *)segmentedControl {
    NSLog(@"%ld",segmentedControl.selectedIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

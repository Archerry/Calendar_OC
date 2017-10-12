//
//  ViewController.m
//  WMHCalendar-OC
//
//  Created by Archer on 2017/10/10.
//  Copyright © 2017年 Archer. All rights reserved.
//

#import "ViewController.h"
#import "WMHCalendarView.h"

@interface ViewController ()
{
    UIButton *clickMe;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    clickMe = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 50)];
    [clickMe setTitle:@"大家好，给大家介绍一下，这是个日历@CalendarView,快按我！！！" forState:UIControlStateNormal];
    [clickMe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clickMe setBackgroundColor:[UIColor redColor]];
    [clickMe.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [clickMe addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickMe];
}

- (void)pressBtn{
    [self.view addSubview:[WMHCalendarView initCalendarViewWithShowView:self.view sureBtnTitleStr:@"确认" buttonIndex:^(NSString *dateStr) {
        NSLog(@"%@",dateStr);
        [clickMe setTitle:dateStr forState:UIControlStateNormal];
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

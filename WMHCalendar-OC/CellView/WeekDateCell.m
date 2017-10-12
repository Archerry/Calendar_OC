//
//  WeekDateCell.m
//  WMHCalendar-OC
//
//  Created by Archer on 2017/10/11.
//  Copyright © 2017年 Archer. All rights reserved.
//

#import "WeekDateCell.h"

#define allScreen [[UIScreen mainScreen] bounds].size

@implementation WeekDateCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCellUI];
    }
    return self;
}

- (void)createCellUI{
    _dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, allScreen.width / 7, 45)];
    [_dateLbl setTextAlignment:NSTextAlignmentCenter];
    [_dateLbl setBackgroundColor:[UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:247.0 / 255.0 alpha:1.0]];
    [self.contentView addSubview:_dateLbl];
}

@end

//
//  CalendarDateCell.m
//  WMHCalendar-OC
//
//  Created by Archer on 2017/10/11.
//  Copyright © 2017年 Archer. All rights reserved.
//

#import "CalendarDateCell.h"

#define allScreen [[UIScreen mainScreen] bounds].size

@implementation CalendarDateCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCellUI];
    }
    return self;
}

- (void)createCellUI{
    _calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, allScreen.width / 7, 45)];
    [_calendarBtn setUserInteractionEnabled:NO];
    [self.contentView addSubview:_calendarBtn];
    
    _calendarLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _calendarBtn.frame.size.width, _calendarBtn.frame.size.height - 0.5)];
    [_calendarLbl setFont:[UIFont systemFontOfSize:13]];
    [_calendarLbl setTextAlignment:NSTextAlignmentCenter];
    [_calendarBtn addSubview:_calendarLbl];
}

@end

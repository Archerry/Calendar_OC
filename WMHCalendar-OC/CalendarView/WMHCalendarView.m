//
//  WMHCalendarView.m
//  WMHCalendar-OC
//
//  Created by Archer on 2017/10/10.
//  Copyright © 2017年 Archer. All rights reserved.
//

#define allScreen [[UIScreen mainScreen] bounds].size

#import "WMHCalendarView.h"
#import "CalendarDateCell.h"
#import "WeekDateCell.h"

@implementation WMHCalendarView
{
    UIButton *lastMonthButton;//上个月的点击的按钮
    UIButton *nextMonthButton;//下个月的点击的按钮
    UILabel *calendarLabel;//显示当天的时间
    UICollectionView *dateCollection;//显示日历的所有时间
    
    NSDate *nowDate;
    NSDate *calendarDate;
    NSString *dateCellIdentifier;
    NSString *calendarCellIdentifier;
    NSString *dateStr;
    
    NSArray *dateArray;
    
    NSIndexPath *lastIndex;
}

+ (instancetype)initCalendarViewWithShowView:(UIView *)showFatherView sureBtnTitleStr:(NSString *)sureBtnTitleStr buttonIndex:(sureButtonClick)buttonIndexTag{
    WMHCalendarView *calendarView = [[WMHCalendarView alloc] initWithFrame:CGRectMake(0, 0, allScreen.width, allScreen.height)];
    [calendarView setClickIndex:buttonIndexTag];
    [calendarView setSureBtnTitle:sureBtnTitleStr];
    [calendarView setCanShowView:showFatherView];
    [calendarView createUI];
    return calendarView;
}

#pragma mark ---------------------------createUI-----------------------
- (void)createUI{
    nowDate = [NSDate date];
    calendarDate = [NSDate date];
    dateCellIdentifier = @"dateIdentifier";
    calendarCellIdentifier = @"calendarIdentifier";
    dateArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    //遮罩
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, allScreen.width, allScreen.height)];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundColor:[UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.5]];
    [self addSubview:backBtn];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backBtn.frame.size.width, 80)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backBtn.frame.size.width, 80)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    [backView addSubview:headerView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [titleLbl setText:@"选择日期"];
    [titleLbl setTextColor:[UIColor blackColor]];
    [titleLbl setFont:[UIFont systemFontOfSize:15]];
    [titleLbl sizeToFit];
    [titleLbl setFrame:CGRectMake(15, 10, titleLbl.frame.size.width, titleLbl.frame.size.height)];
    [headerView addSubview:titleLbl];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 40, 10, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"icon_delete_tcqblb"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeBtn];
    
    calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [calendarLabel setTextColor:[UIColor blackColor]];
    [calendarLabel setFont:[UIFont systemFontOfSize:15]];
    [calendarLabel setTextAlignment:NSTextAlignmentCenter];
    [calendarLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self yearWithDate:calendarDate],[self monthWithDate:calendarDate]]];
    [calendarLabel sizeToFit];
    [calendarLabel setFrame:CGRectMake((backBtn.frame.size.width - 100) / 2, CGRectGetMaxY(titleLbl.frame) + 10, 100, calendarLabel.frame.size.height)];
    [headerView addSubview:calendarLabel];
    
    lastMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(calendarLabel.frame) - 20, calendarLabel.frame.origin.y, 15, 15)];
    [lastMonthButton setImage:[UIImage imageNamed:@"icon_zjt_xzrq"] forState:UIControlStateNormal];
    [lastMonthButton addTarget:self action:@selector(pressLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:lastMonthButton];
    
    nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(calendarLabel.frame) + 5, calendarLabel.frame.origin.y, 15, 15)];
    [nextMonthButton setImage:[UIImage imageNamed:@"icon_jr_jkzx"] forState:UIControlStateNormal];
    [nextMonthButton addTarget:self action:@selector(pressNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextMonthButton];
    
    [headerView setFrame:CGRectMake(0, 0, backBtn.frame.size.width, CGRectGetMaxY(calendarLabel.frame) + 10)];
    
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    [flowLayOut setMinimumLineSpacing:0];
    [flowLayOut setMinimumInteritemSpacing:0];
    [flowLayOut setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayOut setItemSize:CGSizeMake(allScreen.width / 7, 45)];
    
    dateCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), allScreen.width, 315) collectionViewLayout:flowLayOut];
    [dateCollection setBackgroundColor:[UIColor whiteColor]];
    [dateCollection setDelegate:self];
    [dateCollection setDataSource:self];
    [dateCollection registerClass:[WeekDateCell class] forCellWithReuseIdentifier:dateCellIdentifier];
    [dateCollection registerClass:[CalendarDateCell class] forCellWithReuseIdentifier:calendarCellIdentifier];
    [backView addSubview:dateCollection];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, allScreen.height - 45, backBtn.frame.size.width, 45)];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmBtn setTitle:_sureBtnTitle forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:254.0 / 255.0 green:67.0 / 255.0 blue:101.0 / 255.0 alpha:1.0]];
    [backBtn addSubview:confirmBtn];
    
    [backView setFrame:CGRectMake(0, allScreen.height - CGRectGetMaxY(dateCollection.frame) - 45, backBtn.frame.size.width, CGRectGetMaxY(dateCollection.frame))];
}

- (UIColor *)returnBackColorWithIndex:(NSInteger)index{
    switch (index % 7) {
        case 0:
            return [UIColor colorWithRed:3.0 / 255.0 green:54.0 / 255.0 blue:73.0 / 255.0 alpha:1.0];
            break;
        case 1:
            return [UIColor colorWithRed:3.0 / 255.0 green:74.0 / 255.0 blue:93.0 / 255.0 alpha:1.0];
            break;
        case 2:
            return [UIColor colorWithRed:3.0 / 255.0 green:94.0 / 255.0 blue:113.0 / 255.0 alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:3.0 / 255.0 green:114.0 / 255.0 blue:133.0 / 255.0 alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:3.0 / 255.0 green:134.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
            break;
        case 5:
            return [UIColor colorWithRed:3.0 / 255.0 green:154.0 / 255.0 blue:173.0 / 255.0 alpha:1.0];
            break;
        case 6:
            return [UIColor colorWithRed:3.0 / 255.0 green:174.0 / 255.0 blue:193.0 / 255.0 alpha:1.0];
            break;
        case 7:
            return [UIColor colorWithRed:3.0 / 255.0 green:194.0 / 255.0 blue:213.0 / 255.0 alpha:1.0];
            break;
        default:
            return [UIColor whiteColor];
    }
}

#pragma mark ---------------------------Action-----------------------
- (void)clickBackBtn{
    [self removeFromSuperview];
}

- (void)pressLastMonth:(UIButton *)sender{
    lastIndex = nil;
    [UIView transitionWithView:dateCollection duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        calendarDate = [self lastMonthWithDate:calendarDate];
        [calendarLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self yearWithDate:calendarDate],[self monthWithDate:calendarDate]]];
    } completion:^(BOOL finished) {
        [dateCollection reloadData];
    }];
}

- (void)pressNextMonth:(UIButton *)sender{
    lastIndex = nil;
    [UIView transitionWithView:dateCollection duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        calendarDate = [self nextMonthWithDate:calendarDate];
        [calendarLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self yearWithDate:calendarDate],[self monthWithDate:calendarDate]]];
    } completion:^(BOOL finished) {
        [dateCollection reloadData];
    }];
}

- (void)pressConfirm{
    if (dateStr.length > 0) {
        _clickIndex(dateStr);
        [self removeFromSuperview];
    }else{
        [self removeFromSuperview];
    }
}

#pragma mark ---------------------------collectionDelegate-----------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return dateArray.count;
    }else{
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WeekDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateCellIdentifier forIndexPath:indexPath];
        [cell.dateLbl setText:dateArray[indexPath.row]];
        return cell;
    }else{
        CalendarDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:calendarCellIdentifier forIndexPath:indexPath];
        
        NSInteger daysInThisMonth = [self totalDaysInThisMonthWithDate:calendarDate];
        NSInteger firstWeekDay = [self firstWeekDayInThisMonthWithDate:calendarDate];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        [cell.calendarBtn setBackgroundColor:[self returnBackColorWithIndex:i]];
        
        NSInteger nowMonth = [self monthWithDate:calendarDate];
        NSInteger nowYear = [self yearWithDate:calendarDate];
        
        NSInteger lastMonth = 0;
        NSInteger lastYear = 0;
        
        if (nowMonth == 1) {
            lastMonth = 12;
            lastYear = nowYear - 1;
        }else{
            lastMonth = nowMonth - 1;
            lastYear = nowYear;
        }
        
        NSInteger lastTotalDays = [self getDaysInMonthWithYearAndMonth:lastYear month:lastMonth];
        
        if (i < firstWeekDay) {
            [cell.calendarLbl setText:[NSString stringWithFormat:@"%ld",lastTotalDays - firstWeekDay + 1 + indexPath.row]];
            [cell.calendarLbl setTextColor:[UIColor lightGrayColor]];
            [cell.calendarBtn setBackgroundColor:[UIColor whiteColor]];
        }else if (i > firstWeekDay + daysInThisMonth - 1){
            [cell.calendarLbl setText:[NSString stringWithFormat:@"%ld",i - firstWeekDay - daysInThisMonth + 1]];
            [cell.calendarLbl setTextColor:[UIColor lightGrayColor]];
            [cell.calendarBtn setBackgroundColor:[UIColor whiteColor]];
        }else{
            day = i - firstWeekDay + 1;
            if (firstWeekDay == 0) {
                if ((i + 1 == [self dayWithDate:nowDate]) && ([self monthWithDate:nowDate] == [self monthWithDate:calendarDate]) && ([self yearWithDate:nowDate] == [self yearWithDate:calendarDate])) {
                    [cell.calendarBtn setBackgroundColor:[UIColor redColor]];
                }
            }else{
                if ((i == [self dayWithDate:nowDate]) && ([self monthWithDate:nowDate] == [self monthWithDate:calendarDate]) && ([self yearWithDate:nowDate] == [self yearWithDate:calendarDate])) {
                    [cell.calendarBtn setBackgroundColor:[UIColor redColor]];
                }
            }
            [cell.calendarLbl setText:[NSString stringWithFormat:@"%ld",day]];
            [cell.calendarLbl setTextColor:[UIColor whiteColor]];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(allScreen.width / 7, 45);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (lastIndex != nil) {
        CalendarDateCell *cell = (CalendarDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CalendarDateCell *oldCell = (CalendarDateCell *)[collectionView cellForItemAtIndexPath:lastIndex];
        
        NSInteger firstWeekDay = [self firstWeekDayInThisMonthWithDate:calendarDate];
        NSInteger daysInThisMonth = [self totalDaysInThisMonthWithDate:calendarDate];
        
        if (firstWeekDay == 0) {
            if ((lastIndex.item + 1 == [self dayWithDate:nowDate]) && ([self monthWithDate:nowDate] == [self monthWithDate:calendarDate]) && ([self yearWithDate:nowDate] == [self yearWithDate:calendarDate])) {
                [oldCell.calendarLbl setTextColor:[UIColor whiteColor]];
                [oldCell.calendarBtn setBackgroundColor:[UIColor redColor]];
            }else{
                if ((lastIndex.item > firstWeekDay + daysInThisMonth - 1) || (lastIndex.item < firstWeekDay)) {
                    [oldCell.calendarLbl setTextColor:[UIColor lightGrayColor]];
                    [oldCell.calendarBtn setBackgroundColor:[UIColor whiteColor]];
                }else{
                    [oldCell.calendarLbl setTextColor:[UIColor whiteColor]];
                    [oldCell.calendarBtn setBackgroundColor:[self returnBackColorWithIndex:lastIndex.item]];
                }
            }
        }else{
            if ((lastIndex.item == [self dayWithDate:nowDate]) && ([self monthWithDate:nowDate] == [self monthWithDate:calendarDate]) && ([self yearWithDate:nowDate] == [self yearWithDate:calendarDate])) {
                [oldCell.calendarLbl setTextColor:[UIColor whiteColor]];
                [oldCell.calendarBtn setBackgroundColor:[UIColor redColor]];
            }else{
                if ((lastIndex.item > firstWeekDay + daysInThisMonth - 1) || (lastIndex.item < firstWeekDay)) {
                    [oldCell.calendarLbl setTextColor:[UIColor lightGrayColor]];
                    [oldCell.calendarBtn setBackgroundColor:[UIColor whiteColor]];
                }else{
                    [oldCell.calendarLbl setTextColor:[UIColor whiteColor]];
                    [oldCell.calendarBtn setBackgroundColor:[self returnBackColorWithIndex:lastIndex.item]];
                }
            }
        }
        
        lastIndex = indexPath;
        [cell.calendarLbl setTextColor:[UIColor whiteColor]];
        [cell.calendarBtn setBackgroundColor:[UIColor blackColor]];
        
        NSString *dayStr = cell.calendarLbl.text;
        NSString *monthStr = @"";
        NSInteger month = [self monthWithDate:calendarDate];
        
        if ([dayStr integerValue] < 10) {
            dayStr = [NSString stringWithFormat:@"0%@",dayStr];
        }
        
        if (month < 10) {
            monthStr = [NSString stringWithFormat:@"0%ld",month];
        }else{
            monthStr = [NSString stringWithFormat:@"%ld",month];
        }
        
        dateStr = [NSString stringWithFormat:@"%ld-%@-%@",[self yearWithDate:calendarDate],monthStr,dayStr];
    }else{
        CalendarDateCell *cell = (CalendarDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        lastIndex = indexPath;
        [cell.calendarLbl setTextColor:[UIColor whiteColor]];
        [cell.calendarBtn setBackgroundColor:[UIColor blackColor]];
        
        NSString *dayStr = cell.calendarLbl.text;
        NSString *monthStr = @"";
        NSInteger month = [self monthWithDate:calendarDate];
        
        if ([dayStr integerValue] < 10) {
            dayStr = [NSString stringWithFormat:@"0%@",dayStr];
        }
        
        if (month < 10) {
            monthStr = [NSString stringWithFormat:@"0%ld",month];
        }else{
            monthStr = [NSString stringWithFormat:@"%ld",month];
        }
        
        dateStr = [NSString stringWithFormat:@"%ld-%@-%@",[self yearWithDate:calendarDate],monthStr,dayStr];
    }
}

#pragma mark ---------------------------dateCalculate-----------------------
//计算日期是几号
- (NSInteger)dayWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.day;
}

//计算日期是几月
- (NSInteger)monthWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.month;
}

//计算日期是哪年
- (NSInteger)yearWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.year;
}

//计算每个月1号对应周几
- (NSInteger)firstWeekDayInThisMonthWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    calendar.firstWeekday = 1;
    component.day = 1;
    
    NSDate *firstDate = [calendar dateFromComponents:component];
    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDate] - 1;
}

//计算当前月份天数
- (NSInteger)totalDaysInThisMonthWithDate:(NSDate *)date{
    return [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//计算指定月天数
- (NSInteger)getDaysInMonthWithYearAndMonth:(NSInteger)year month:(NSInteger)month{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    
    NSString *monthStr = @"";
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld",month];
    }else{
        monthStr = [NSString stringWithFormat:@"%ld",month];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%@",year,monthStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    //NSCalendarIdentifierGregorian公历日历的意思
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

//上一个月
- (NSDate *)lastMonthWithDate:(NSDate *)date{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.month = -1;
    /*
         NSCalendarWrapComponents
             Specifies that the components specified for an NSDateComponents object should be incremented and wrap around to zero/one on overflow, but should not cause higher units to be incremented.
             指定为NSDateComponents对象指定的组件应该递增，并在溢出时循环为零/ 1，但不应导致更高的单位增加。
         NSCalendarMatchStrictly
             Specifies that the operation should travel as far forward or backward as necessary looking for a match.
             指定操作应该根据需要前进或后退，寻找匹配。
         NSCalendarSearchBackwards
             Specifies that the operation should travel backwards to find the previous match before the given date.
             指定操作向后移动以在给定日期之前找到先前的匹配。
         NSCalendarMatchPreviousTimePreservingSmallerUnits
             Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the previous existing value of the missing unit and preserves the lower units' values.
             指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺失单元的先前存在的值，并保留较低单位的值。
         NSCalendarMatchNextTimePreservingSmallerUnits
             Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the next existing value of the missing unit and preserves the lower units' values.
             指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺少单元的下一个现有值并保留较低单位的值。
         NSCalendarMatchNextTime
             Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the next existing value of the missing unit and does not preserve the lower units' values.
             指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺少单元的下一个现有值，并且不保留较低单位的值。
         NSCalendarMatchFirst
             Specifies that, if there are two or more matching times, the operation should return the first occurrence.
             指定如果有两个或更多匹配的时间，操作应该返回第一个出现的。
         NSCalendarMatchLast
             Specifies that, if there are two or more matching times, the operation should return the last occurrence.
             指定如果有两个或更多匹配的时间，则操作应返回最后一次出现的。
         */
    return [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:NSCalendarMatchStrictly];
}

//下一个月
- (NSDate *)nextMonthWithDate:(NSDate *)date{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.month = +1;
    return [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:NSCalendarMatchStrictly];
}
@end

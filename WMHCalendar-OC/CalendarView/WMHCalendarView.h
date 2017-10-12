//
//  WMHCalendarView.h
//  WMHCalendar-OC
//
//  Created by Archer on 2017/10/10.
//  Copyright © 2017年 Archer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sureButtonClick)(NSString *dateStr);

@interface WMHCalendarView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain)UIView * canShowView;//该视图可以显示的视图图层
@property(nonatomic, copy)NSString * sureBtnTitle;//按钮显示的标题
@property(nonatomic, copy)sureButtonClick clickIndex;

+(instancetype)initCalendarViewWithShowView:(UIView *)showFatherView sureBtnTitleStr:(NSString *)sureBtnTitleStr buttonIndex:(sureButtonClick)buttonIndexTag;

@end

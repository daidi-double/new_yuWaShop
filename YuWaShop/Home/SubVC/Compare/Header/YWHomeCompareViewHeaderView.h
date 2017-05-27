//
//  YWHomeCompareViewHeaderView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJSegmentedControl.h"

@interface YWHomeCompareViewHeaderView : UIView<YJSegmentedControlDelegate>

@property (nonatomic,copy)void (^showTypeBlock)(BOOL isShowAllType);
@property (nonatomic,copy)void (^changeSubTypeBlock)();

@property (nonatomic,copy)void (^compareTypeBlock)(NSInteger compareType);

@property (nonatomic,strong)YJSegmentedControl * typeSegmentedControl;
@property (nonatomic,assign)NSInteger showTypeSelection;

@end

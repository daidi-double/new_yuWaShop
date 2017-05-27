//
//  YWHomeAdvanceOrderTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/1.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeAdvanceOrderModel.h"

@interface YWHomeAdvanceOrderTableViewCell : UITableViewCell
@property (nonatomic,copy)void (^rePlayBlock)();
@property (nonatomic,copy)void (^rejectBlock)();
@property (nonatomic,strong)YWHomeAdvanceOrderModel * model;

@property (nonatomic,assign)NSInteger status;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nmberLabel;

@property (weak, nonatomic) IBOutlet UILabel *rePlayLabel;
@property (weak, nonatomic) IBOutlet UIButton *rePlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UILabel *myRePlayLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replayLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customReplayHeight;

@end

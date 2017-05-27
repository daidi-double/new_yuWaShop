//
//  YWHomeQuickPayListTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeQuickPayListModel.h"

@interface YWHomeQuickPayListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderSNStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSNLabel;
@property (nonatomic,strong)YWHomeQuickPayListModel * model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *GetMoneyLabel;


@property (weak, nonatomic) IBOutlet UILabel *showLabel;




@end

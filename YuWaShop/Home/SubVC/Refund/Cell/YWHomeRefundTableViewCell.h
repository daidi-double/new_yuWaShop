//
//  YWHomeRefundTableViewCell.h
//  YuWaShop
//
//  Created by TianWei You on 16/12/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeRefundModel.h"

@interface YWHomeRefundTableViewCell : UITableViewCell

@property (nonatomic,copy)void (^rePlayBlock)(NSString *);

@property (nonatomic,strong)YWHomeRefundModel * model;
@property (nonatomic,assign)NSInteger status;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *rePlayBtn;


@end

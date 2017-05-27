//
//  YWHomeOrderNoticaficationTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/1.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeNoPayListModel.h"

@interface YWHomeOrderNoticaficationTableViewCell : UITableViewCell

@property (nonatomic,copy)void (^rePlayBlock)();

@property (nonatomic,strong)YWHomeNoPayListModel * model;

@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nmberLabel;

@property (weak, nonatomic) IBOutlet UILabel *rePlayLabel;
@property (weak, nonatomic) IBOutlet UIButton *rePlayBtn;

@end

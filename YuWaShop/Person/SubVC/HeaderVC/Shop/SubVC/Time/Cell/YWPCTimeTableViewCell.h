//
//  YWPCTimeTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWPCTimeModel.h"

@interface YWPCTimeTableViewCell : UITableViewCell

@property (nonatomic,strong)YWPCTimeModel * model;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTimeLabel;


@end

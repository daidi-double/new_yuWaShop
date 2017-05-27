//
//  YWPersonTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWPersonCenterModel.h"

@interface YWPersonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@property (nonatomic,strong)YWPersonCenterModel * model;

@end

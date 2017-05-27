//
//  RBNodeAddToAldumTableViewCell.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBNodeAddToAldumModel.h"

@interface RBNodeAddToAldumTableViewCell : UITableViewCell

@property (nonatomic,strong)RBNodeAddToAldumModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

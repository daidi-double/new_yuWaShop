//
//  YWMessageAddressBookTableViewCell.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWMessageAddressBookModel.h"
@interface YWMessageAddressBookTableViewCell : UITableViewCell
@property (nonatomic,strong)YWMessageAddressBookModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

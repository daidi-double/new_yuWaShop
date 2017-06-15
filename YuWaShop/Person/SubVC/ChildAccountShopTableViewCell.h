//
//  ChildAccountShopTableViewCell.h
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainAccountListModel.h"
@interface ChildAccountShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (nonatomic,strong)MainAccountListModel * model;
@end

//
//  ChildAccountTableViewCell.h
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildModel.h"
@interface ChildAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (nonatomic,strong)ChildModel * childModel;

@end

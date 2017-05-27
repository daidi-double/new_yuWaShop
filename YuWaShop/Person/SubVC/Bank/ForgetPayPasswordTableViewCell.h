//
//  ForgetPayPasswordTableViewCell.h
//  YuWaShop
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPayPasswordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankCardLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoTextfiled;
@property (nonatomic,copy) void(^phoneTextViewBlock)(NSString * phone);
@property (nonatomic,assign) NSInteger status;
@end

//
//  YWPCTTimeNameTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPCTTimeNameTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,copy)void (^namedBlock)(NSString *);

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

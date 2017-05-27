//
//  YWPCTIsAllDayTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPCTIsAllDayTableViewCell : UITableViewCell

@property (nonatomic,copy)void (^payAllDayBlock)(BOOL);

@property (weak, nonatomic) IBOutlet UISwitch *allDaySwich;
@property (nonatomic,assign)BOOL isPayAllDay;

@end

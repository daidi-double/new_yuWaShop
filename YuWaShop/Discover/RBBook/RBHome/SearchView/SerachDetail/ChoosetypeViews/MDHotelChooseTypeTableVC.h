//
//  MDHotelChooseTypeTableVC.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHotelChooseTypeTableVC : UITableView

@property (nonatomic,copy)void(^choosedTypeBlock)(NSString *,NSString *);

@end

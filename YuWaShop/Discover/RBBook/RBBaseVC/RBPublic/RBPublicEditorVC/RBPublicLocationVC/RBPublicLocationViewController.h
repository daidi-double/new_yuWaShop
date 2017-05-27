//
//  RBPublicLocationViewController.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWLocationBasicViewController.h"

@interface RBPublicLocationViewController : JWLocationBasicViewController

@property (nonatomic,copy)void (^locationChooseBlock)(NSString *);

@end

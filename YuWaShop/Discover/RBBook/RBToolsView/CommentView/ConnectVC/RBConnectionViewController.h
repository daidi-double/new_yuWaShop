//
//  RBConnectionViewController.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/14.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBConnectionViewController : UIViewController

@property (nonatomic,copy)void (^connectNameBlock)(NSString *);

@end

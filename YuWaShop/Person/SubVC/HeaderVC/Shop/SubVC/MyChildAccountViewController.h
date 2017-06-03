//
//  MyChildAccountViewController.h
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyChildAccountViewController : UIViewController
@property (nonatomic,copy)void (^nameBlock)(NSString * name);
@end

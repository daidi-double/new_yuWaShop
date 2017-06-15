//
//  ShopAccountViewController.h
//  雨掌柜
//
//  Created by double on 17/6/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopAccountViewController : UIViewController
@property(nonatomic,copy)void(^shopBlock)(NSString *,NSString*);
@end

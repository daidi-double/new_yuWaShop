//
//  JWTagScrollView.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTagScrollView : UIScrollView

@property (nonatomic,copy)void (^chooseTagBlock)(NSString * tag);
@property (nonatomic,strong)NSArray * tagArr;

@end

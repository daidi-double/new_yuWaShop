//
//  YWPersonHeaderView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPersonHeaderView : UIView

@property (nonatomic,copy)void (^chooseBtnBlock)(NSInteger choosedBtn);//1门店2会员3分红
@property (nonatomic,copy)void (^iconBtnBlock)();
@property (nonatomic,strong)NSMutableArray * BGImgArr;

@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BGImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageTop;



@end

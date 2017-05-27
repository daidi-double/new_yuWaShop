//
//  YWPersonShopHeaderView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWPersonShopHeaderModel.h"
@interface YWPersonShopHeaderView : UIView

@property (nonatomic,strong)YWPersonShopHeaderModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UIView *imageCountLabBGView;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCountBGWidth;

- (void)refreshUI;

@end

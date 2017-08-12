//
//  YWPersonShopHeaderView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWPersonShopHeaderModel.h"

@protocol YWPersonShopHeaderViewDelegate <NSObject>

- (void)YWPersonShopHeaderViewToPhotoPage;

@end

@interface YWPersonShopHeaderView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,strong)YWPersonShopHeaderModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UIView *imageCountLabBGView;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCountBGWidth;
@property (nonatomic,assign)id<YWPersonShopHeaderViewDelegate>delegate;

- (void)refreshUI;

@end


//
//  RBNodeDetailImageHeader.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBHomeListImagesModel.h"
#import "RBPublicTagSaveModel.h"

@interface RBNodeDetailImageHeader : UIView

@property (nonatomic,strong)NSArray * tagArr;

@property (nonatomic,strong)UIScrollView * scrollImageView;
@property (nonatomic,strong)NSArray * imageList;

//滑动刷新
- (void)refreshWithHeight:(CGFloat)height;

@end

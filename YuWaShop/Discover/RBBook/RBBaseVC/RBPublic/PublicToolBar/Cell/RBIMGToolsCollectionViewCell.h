//
//  RBIMGToolsCollectionViewCell.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Utility.h"
#import "JWTools.h"

@interface RBIMGToolsCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign)NSInteger idx;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,copy)NSString * filterName;


@end

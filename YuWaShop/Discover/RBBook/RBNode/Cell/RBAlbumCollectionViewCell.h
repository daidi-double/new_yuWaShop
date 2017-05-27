//
//  RBAlbumCollectionViewCell.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/9.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBCenterAlbumModel.h"
#import "NSString+JWAppendOtherStr.h"

@interface RBAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)RBCenterAlbumModel * model;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *actorlabel;


@end

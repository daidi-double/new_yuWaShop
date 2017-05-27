//
//  JWTagCollectionViewCell.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTagCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign)BOOL choosed;
@property (nonatomic,strong)UIColor * chooseColor;
@property (nonatomic,strong)UIColor * fontColor;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

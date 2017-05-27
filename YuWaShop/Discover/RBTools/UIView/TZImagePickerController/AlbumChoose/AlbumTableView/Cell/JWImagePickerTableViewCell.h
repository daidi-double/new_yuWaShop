//
//  JWImagePickerTableViewCell.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZAssetModel.h"
#import "TZImageManager.h"

@class TZAlbumModel;

@interface JWImagePickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)TZAlbumModel * model;

@end

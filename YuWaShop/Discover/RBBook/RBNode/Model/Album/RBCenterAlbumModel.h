//
//  RBCenterAlbumModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBHomeUserModel.h"

@interface RBCenterAlbumModel : NSObject

@property (nonatomic,strong)NSArray * images;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * privacy;
@property (nonatomic,copy)NSString * total;
@property (nonatomic,copy)NSString * fans;
@property (nonatomic,copy)NSString * desc;
@property (nonatomic,copy)NSString * aldumID;
@property (nonatomic,strong)RBHomeUserModel * user;

@end

//
//  RBHomeUserModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBHomeUserModel : NSObject

//RBCenternodeModel&RBHomeModel&RBNodeShowModel
@property (nonatomic,copy)NSString * images;
@property (nonatomic,copy)NSString * userid;
@property (nonatomic,copy)NSString * nickname;

//RBHomeModel
@property (nonatomic,copy)NSString * isbirthday;
@property (nonatomic,copy)NSString * red_club_level;
@property (nonatomic,copy)NSString * followed;

//RBNodeShowModel
@property (nonatomic,copy)NSString * likes;
@property (nonatomic,copy)NSString * user_type;

@end

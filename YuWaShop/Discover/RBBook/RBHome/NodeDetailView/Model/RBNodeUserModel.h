//
//  RBNodeUserModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBHomeUserModel.h"
#import "RBNodeUserLevelModel.h"

@interface RBNodeUserModel : RBHomeUserModel

//父类中有用的:userid,likes,red_club_level,isbirthday,images,nickname
@property (nonatomic,copy)NSString * red_club;
@property (nonatomic,copy)NSString * fstatus;
@property (nonatomic,copy)NSString * fans_total;
@property (nonatomic,copy)NSString * discoverys_total;
@property (nonatomic,copy)NSString * relationship_info;


@property (nonatomic,strong)RBNodeUserLevelModel * level;

@end

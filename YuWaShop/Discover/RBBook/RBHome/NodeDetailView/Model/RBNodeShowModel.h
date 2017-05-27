//
//  RBNodeShowModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBNodeShowTagModel.h"
#import "RBHomeUserModel.h"
#import "RBNodeShowShowInfoModel.h"
#import "RBNodeShowCommentModel.h"
#import "RBHomeListImagesModel.h"
#import "RBNodeUserModel.h"
#import "RBNodeTagModel.h"

@interface RBNodeShowModel : NSObject

@property (nonatomic,copy)NSString * location;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * likes;
@property (nonatomic,copy)NSString * is_fans;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * share_link;
@property (nonatomic,copy)NSString * inlikes;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * geo;
@property (nonatomic,copy)NSString * nodeID;
@property (nonatomic,copy)NSString * level;
@property (nonatomic,copy)NSString * enabled;
@property (nonatomic,copy)NSString * infavs;
@property (nonatomic,copy)NSString * area;
@property (nonatomic,copy)NSString * comments;
@property (nonatomic,copy)NSString * fav_count;
@property (nonatomic,copy)NSString * desc;

@property (nonatomic,strong)RBNodeShowShowInfoModel * share_info;
@property (nonatomic,strong)RBNodeUserModel * user;

@property (nonatomic,strong)NSArray * filter_tags;
@property (nonatomic,strong)NSArray * relatedgoods_list;
@property (nonatomic,strong)NSArray * like_users;
@property (nonatomic,strong)NSArray * comments_list;
@property (nonatomic,strong)NSArray * images_list;

@property (nonatomic,strong)NSArray * tags_info_2;

+ (NSMutableDictionary *)dataDicSetWithDic:(NSDictionary *)dic;

@end

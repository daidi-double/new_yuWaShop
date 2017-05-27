//
//  RBHomeModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBHomeUserModel.h"
#import "RBHomeRecommendModel.h"

#import "RBHomeListGoodsModel.h"
#import "RBHomeListCommentsModel.h"
#import "RBHomeListImagesModel.h"


//"note_id": "32",
//"user_id": "4",
//"info": "Sad%F0%9F%98%8A%F0%9F%98%8A",
//"title": "dda23",
//"likes": "0",
//"nickname": "Scarlet",
//"header_img": "",
//"first_img": "http://114.215.252.104/Public/Upload/20161103/14781828997859.png",
//"first_img_width": 750,
//"first_img_height": 498

@interface RBHomeModel : NSObject
//Home&&NodeDetail
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * homeID;
@property (nonatomic,copy)NSString * likes;//点赞 0 赞
@property (nonatomic,copy)NSString * inlikes;
@property (nonatomic,copy)NSString * name;

@property (nonatomic,strong)RBHomeUserModel * user;

@property (nonatomic,strong)NSArray * images_list;
//Home
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * share_link;
@property (nonatomic,copy)NSString * show_more;
@property (nonatomic,copy)NSString * level;
@property (nonatomic,copy)NSString * cursor_score;
@property (nonatomic,copy)NSString * infavs;
@property (nonatomic,copy)NSString * comments;
@property (nonatomic,copy)NSString * fav_count;
@property (nonatomic,copy)NSString * desc;

@property (nonatomic,strong)RBHomeRecommendModel * recommend;

@property (nonatomic,strong)NSArray * relatedgoods_list;
@property (nonatomic,strong)NSArray * newest_comments;

@property (nonatomic,assign)CGFloat cellHeight;

+ (NSMutableDictionary *)dataDicSetWithDic:(NSDictionary *)dic;

@end

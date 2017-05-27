//
//  RBnodeShowCommentModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBNodeShowCommentTargetModel.h"

@interface RBNodeShowCommentModel : NSObject

@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * like_count;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * commentID;
@property (nonatomic,copy)NSString * liked;

@property (nonatomic,strong)RBNodeShowCommentTargetModel * target_comment;
@property (nonatomic,strong)RBHomeUserModel * user;

+ (NSMutableDictionary *)dataDicSetWithDic:(NSDictionary *)dic;

@end

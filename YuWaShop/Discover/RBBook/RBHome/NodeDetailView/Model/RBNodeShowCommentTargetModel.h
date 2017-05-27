//
//  RBNodeShowCommentTargetModel.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBHomeUserModel.h"

@interface RBNodeShowCommentTargetModel : NSObject

@property (nonatomic,copy)NSString * like_count;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * targetID;

@property (nonatomic,strong)RBHomeUserModel * user;


@end

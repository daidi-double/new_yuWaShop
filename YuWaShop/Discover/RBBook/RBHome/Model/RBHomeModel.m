//
//  RBHomeModel.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBHomeModel.h"
#import "JWTools.h"

@implementation RBHomeModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"relatedgoods_list" : [RBHomeListGoodsModel class],@"newest_comments" : [RBHomeListCommentsModel class],@"images_list" : [RBHomeListImagesModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"homeID" : @"note_id"};
}

+ (NSMutableDictionary *)dataDicSetWithDic:(NSDictionary *)dic{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * userDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary * imgDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dataDic setObject:dic[@"note_id"]?dic[@"note_id"]:@"" forKey:@"note_id"];
    NSString * desc = [JWTools stringWithUTF8JW:dic[@"info"]?dic[@"info"]:@""]?[JWTools stringWithUTF8JW:dic[@"info"]?dic[@"info"]:@""]:@"";
    [dataDic setObject:desc forKey:@"desc"];
    [dataDic setObject:dic[@"inlikes"]?dic[@"inlikes"]:@"0" forKey:@"inlikes"];
    [dataDic setObject:dic[@"likes"]?dic[@"likes"]:@"" forKey:@"likes"];
    [dataDic setObject:dic[@"title"]?dic[@"title"]:@"" forKey:@"title"];
    
    [userDic setObject:dic[@"header_img"]?dic[@"header_img"]:@"" forKey:@"images"];
    [userDic setObject:dic[@"user_id"]?dic[@"user_id"]:@"" forKey:@"userid"];
    [userDic setObject:dic[@"nickname"]?dic[@"nickname"]:@"" forKey:@"nickname"];
    [userDic setObject:dic[@"user_type"]?dic[@"user_type"]:@"" forKey:@"user_type"];
    [dataDic setObject:userDic forKey:@"user"];
    
    [imgDic setObject:dic[@"first_img"]?dic[@"first_img"]:@"" forKey:@"original"];
    [imgDic setObject:dic[@"first_img"]?dic[@"first_img"]:@"" forKey:@"url"];
    [imgDic setObject:dic[@"first_img_height"]?dic[@"first_img_height"]:@"320" forKey:@"height"];
    [imgDic setObject:dic[@"first_img_width"]?dic[@"first_img_width"]:@"320" forKey:@"width"];
    [imgArr addObject:imgDic];
    [dataDic setObject:imgArr forKey:@"images_list"];
    return dataDic;
}

@end

//
//  RBNodeShowModel.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeShowModel.h"
#import "JWTools.h"

@implementation RBNodeShowModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"filter_tags" : [RBNodeShowTagModel class],@"like_users" : [RBHomeUserModel class],@"comments_list" : [RBNodeShowCommentModel class],@"images_list" : [RBHomeListImagesModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"nodeID":@"id"};
}

+ (NSMutableDictionary *)dataDicSetWithDic:(NSDictionary *)dic{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary * userDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * commentArr = [NSMutableArray arrayWithCapacity:0];
    
    NSData *jsonData = [dic[@"tag"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary * tagDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    [dataDic setObject:dic[@"location"]?dic[@"location"]:@"" forKey:@"location"];
    [dataDic setObject:dic[@"time"]?dic[@"time"]:@"1477964900" forKey:@"time"];
    [dataDic setObject:dic[@"likes"]?dic[@"likes"]:@"0" forKey:@"likes"];
    [dataDic setObject:dic[@"inlikes"]?dic[@"inlikes"]:@"0" forKey:@"inlikes"];
    [dataDic setObject:dic[@"title"]?dic[@"title"]:@"" forKey:@"title"];
    [dataDic setObject:dic[@"infavs"]?dic[@"infavs"]:@"0" forKey:@"infavs"];
    [dataDic setObject:dic[@"favs"]?dic[@"favs"]:@"0" forKey:@"fav_count"];
    [dataDic setObject:dic[@"comments"]?dic[@"comments"]:@"" forKey:@"comments"];
    NSString * desc = [JWTools stringWithUTF8JW:dic[@"content"]?dic[@"content"]:@""]?[JWTools stringWithUTF8JW:dic[@"content"]?dic[@"content"]:@""]:@"";
    [dataDic setObject:desc forKey:@"desc"];
    [dataDic setObject:dic[@"is_fans"]?dic[@"is_fans"]:@"0" forKey:@"is_fans"];
        
    [userDic setObject:dic[@"header_img"]?dic[@"header_img"]:@"" forKey:@"images"];
    [userDic setObject:dic[@"user_id"]?dic[@"user_id"]:@"0" forKey:@"userid"];
    [userDic setObject:dic[@"nickname"]?dic[@"nickname"]:@"" forKey:@"nickname"];
    [userDic setObject:dic[@"user_type"]?dic[@"user_type"]:@"" forKey:@"user_type"];
    
    NSArray * imgArrTemp = dic[@"images_list"];
    for (int i = 0; i<imgArrTemp.count; i++) {
        NSDictionary * imgDicTemp = imgArrTemp[i];
        NSMutableDictionary * imgDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [imgDic setObject:imgDicTemp[@"url"]?imgDicTemp[@"url"]:@"" forKey:@"original"];
        [imgDic setObject:imgDicTemp[@"url"]?imgDicTemp[@"url"]:@"" forKey:@"url"];
        [imgDic setObject:imgDicTemp[@"img_height"]?imgDicTemp[@"img_height"]:@"320" forKey:@"height"];
        [imgDic setObject:imgDicTemp[@"img_width"]?imgDicTemp[@"img_width"]:@"320" forKey:@"width"];
        [imgArr addObject:imgDic];
    }
    
    NSArray * commentArrTemp = dic[@"comments_list"];
    for (int i = 0; i<commentArrTemp.count; i++) {
        NSDictionary * commentDicTemp = commentArrTemp[i];
        NSMutableDictionary * commentDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [commentDic setObject:commentDicTemp[@"status"]?commentDicTemp[@"status"]:@"" forKey:@"status"];
        NSString * content = commentDicTemp[@"customer_content"]?commentDicTemp[@"customer_content"]:@"";
        NSString * descComment = [JWTools stringWithUTF8JW:content]?[JWTools stringWithUTF8JW:content]:@"";
        [commentDic setObject:descComment forKey:@"content"];
        [commentDic setObject:commentDicTemp[@"ctime"]?commentDicTemp[@"ctime"]:@"" forKey:@"time"];
        
        NSMutableDictionary * userDicTemp = [NSMutableDictionary dictionaryWithCapacity:0];
        [userDicTemp setObject:commentDicTemp[@"customer_header_img"]?commentDicTemp[@"customer_header_img"]:@"" forKey:@"images"];
        [userDicTemp setObject:commentDicTemp[@"customer_uid"]?commentDicTemp[@"customer_uid"]:@"0" forKey:@"userid"];
        [userDicTemp setObject:commentDicTemp[@"customer_nickname"]?commentDicTemp[@"customer_nickname"]:@"" forKey:@"nickname"];
        [commentDic setObject:userDicTemp forKey:@"user"];
        
        [commentArr addObject:commentDic];
    }
    
    [dataDic setObject:userDic forKey:@"user"];
    [dataDic setObject:imgArr forKey:@"images_list"];
    [dataDic setObject:commentArr forKey:@"comments_list"];
    if (tagDic[@"tags_info_2"]) {
        [dataDic setObject:tagDic[@"tags_info_2"] forKey:@"tags_info_2"];
    }
    return dataDic;
}

@end

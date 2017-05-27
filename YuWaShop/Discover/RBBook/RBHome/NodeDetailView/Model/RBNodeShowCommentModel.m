//
//  RBnodeShowCommentModel.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeShowCommentModel.h"
#import "JWTools.h"

@implementation RBNodeShowCommentModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"commentID":@"id"};
}

+ (NSMutableDictionary *)dataDicSetWithDic:(NSDictionary *)dic{
    NSMutableDictionary * commentDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [commentDic setObject:dic[@"status"]?dic[@"status"]:@"" forKey:@"status"];
    NSString * content = dic[@"customer_content"]?dic[@"customer_content"]:@"";
    NSString * desc = [JWTools stringWithUTF8JW:content]?[JWTools stringWithUTF8JW:content]:@"";
    [commentDic setObject:desc forKey:@"content"];
    [commentDic setObject:dic[@"ctime"]?dic[@"ctime"]:@"" forKey:@"time"];
    
    NSMutableDictionary * userDicTemp = [NSMutableDictionary dictionaryWithCapacity:0];
    [userDicTemp setObject:dic[@"customer_header_img"]?dic[@"customer_header_img"]:@"" forKey:@"images"];
    [userDicTemp setObject:dic[@"customer_uid"]?dic[@"customer_uid"]:@"0" forKey:@"userid"];
    [userDicTemp setObject:dic[@"customer_nickname"]?dic[@"customer_nickname"]:@"" forKey:@"nickname"];
    [commentDic setObject:userDicTemp forKey:@"user"];
    return commentDic;
}

@end

//
//  ShopdetailModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/3.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopdetailModel : NSObject
//"customer_content" = 非常不满意  我不管 就是个巨坑 ,
//                     "score" = 5.0,
//                     "ctime" = 1480502640,
//                     "id" = 16,
//                     "customer_name" = bbb,
//                     "customer_img" = http://114.215.252.104/Public/Upload/20161121/14797210839275.png,
//                     "img_url" = [{"title":"\u6d4b\u8bd51","url":"http:\/\/114.215.252.104\/Public\/Upload\/20161103\/1.jpg"},{"title":"\u6d4b\u8bd5122","url":"http:\/\/114.215.252.104\/Public\/Upload\/20161103\/2.jpg"}],
//                     "customer_uid" = 12,


@property(nonatomic,strong)NSString*customer_name;
@property(nonatomic,strong)NSString*customer_img;
@property(nonatomic,strong)NSString*score;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*customer_content;
@property(nonatomic,strong)NSString*customer_uid;   //这个没用
@property(nonatomic,strong)NSString*id;//回复的id
@property(nonatomic,strong)NSString*seller_content;                  //商家评论字段
@property(nonatomic,strong)NSArray*img_url;
@property(nonatomic,strong)NSArray * rep_list;//回复数组
@end

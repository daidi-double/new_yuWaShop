//
//  CommentModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/4.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopdetailModel.h"


//    "total_comment" = 1,
//    "totay_comment" = 0,
//    "lists" = 1 (
//                 {
//                     "customer_content" = 非常不满意  我不管 就是个巨坑 ,
//                     "score" = 5.0,
//                     "ctime" = 1480502640,
//                     "id" = 16,
//                     "customer_name" = bbb,
//                     "customer_img" = http://114.215.252.104/Public/Upload/20161121/14797210839275.png,
//                     "img_url" = [{"title":"\u6d4b\u8bd51","url":"http:\/\/114.215.252.104\/Public\/Upload\/20161103\/1.jpg"},{"title":"\u6d4b\u8bd5122","url":"http:\/\/114.215.252.104\/Public\/Upload\/20161103\/2.jpg"}],
//                     "customer_uid" = 12,
//                 }, 
//                 ),
//    "totay_bad_comment" = 0,
//    },


@interface CommentModel : NSObject
@property(nonatomic,strong)NSString*total_comment;
@property(nonatomic,strong)NSString*totay_comment;
@property(nonatomic,strong)NSString*totay_bad_comment;






@end

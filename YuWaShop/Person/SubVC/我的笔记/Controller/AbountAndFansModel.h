//
//  AbountAndFansModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbountAndFansModel : NSObject

//fans = 0;
//"header_img" = "http://114.215.252.104/Public/Upload/20161116/14793057114680.png";
//"is_attention" = 1;
//nickname = 13788845887;
//"note_num" = 0;
//uid = 19;


@property(nonatomic,strong)NSString*uid;   //这个用户的uid
@property(nonatomic,strong)NSString*header_img;   //图片
@property(nonatomic,strong)NSString*nickname;   //名字
@property(nonatomic,strong)NSString*note_num;   //多少条笔记
@property(nonatomic,strong)NSString*fans;    //多少粉丝
@property(nonatomic,strong)NSString * user_type;
@property(nonatomic,assign)BOOL is_attention;           //是否关注了  1为关注了   0为未关注


@end

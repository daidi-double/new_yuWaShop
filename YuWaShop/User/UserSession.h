//
//  UserSession.h
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/31.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YWUserShopAdminModel.h"

@interface UserSession : NSObject


@property (nonatomic,assign)NSInteger uid;//uid
@property (nonatomic,copy)NSString * token;   //用户登录后标识
@property (nonatomic,copy)NSString * account;  //账户
@property (nonatomic,copy)NSString * mobile;
@property (nonatomic,copy)NSString * password;   //密码
@property (nonatomic,copy)NSString * hxPassword;   //环信密码
@property (nonatomic,copy)NSString * inviteID;  //邀请ID

@property (nonatomic,copy)NSString * logo;//头像
@property (nonatomic,copy)NSString * nickName;//昵称
@property (nonatomic,copy)NSString * sex;//性别
@property (nonatomic,copy)NSString * birthDay;//生日
@property (nonatomic,copy)NSString * local;   //常驻地
@property (nonatomic,copy)NSString * personality;   //个人签名

@property (nonatomic,copy)NSString * attentionCount;//关注数
@property (nonatomic,copy)NSString * fans;//粉丝
@property (nonatomic,copy)NSString * praised;//被赞数
@property (nonatomic,copy)NSString * collected;//被收藏
@property (nonatomic,copy)NSString * aldumCount;  //专辑个数
@property (nonatomic,copy)NSString * money; //钱
@property (nonatomic,copy)NSString * last_login_time;
@property (nonatomic,copy)NSString * reg_time;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString * email;
@property (nonatomic,copy)NSString * sale_id;

//note_nums  album_nums  comment_nums
@property(nonatomic,strong)NSString*note_nums;    //多少条笔记
@property(nonatomic,strong)NSString*album_nums;    //多少个专辑
@property(nonatomic,strong)NSString*comment_nums;  //多少条评论
@property(nonatomic,strong)NSString*today_money;  //今日收益

@property (nonatomic,assign)NSInteger isVIP;//是否是会员 1普通用户2销售3商家

//@property(nonatomic,copy)NSString * currency; //货币
//已经登录
@property(nonatomic,assign)BOOL isLogin;   //是否登录

@property (nonatomic,assign)NSInteger baobaoLV;
@property (nonatomic,assign)NSInteger baobaoEXP;
@property (nonatomic,assign)NSInteger baobaoNeedEXP;

@property (nonatomic,assign)BOOL isNewNoticafication;//查看新消息
@property(nonatomic,assign)NSInteger comfired_Status;   //是否实名认证1待审核 2通过 3拒绝 4未提交
@property (nonatomic,assign)CGFloat cut;//买单收银折扣
@property (nonatomic,copy)NSString * phone;//客服电话
@property (nonatomic,copy)NSString * serventPhone;//营销顾问电话,邀请人电话
@property (nonatomic,copy)NSString * agreement;//认证协议

@property (nonatomic,copy)NSString * shopType;//店铺所属大类
@property (nonatomic,strong)NSArray * shopSubTypeArr;//店铺所选小类
@property (nonatomic,copy)NSString * shopTypeID;//店铺所属大类
@property (nonatomic,strong)NSArray * shopSubTypeIDArr;//店铺所选小类

@property (nonatomic,assign)CGFloat star;
@property (nonatomic,copy)NSString * infrastructure;


+ (UserSession*)instance;  //创建单例
+ (void)clearUser;   //退出登录 删除数据

+ (void)saveUserLoginWithAccount:(NSString *)account withPassword:(NSString *)password;  //save login data
+ (void)userShoperSalePhone;

+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic;//save user data
+ (void)autoLoginRequestWithPragram:(NSDictionary *)pragram;

+ (BOOL)userToComfired;
+ (void)userCompareType;
+ (void)refreshNoticaficationWithIsNewNoticafication:(BOOL)isNewNoticafication;

@end

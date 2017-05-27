//
//  YWFansViewController.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TheFriends){
    TheFirendsAbount=0,
    TheFirendsFans,
    TheFirendsTaAbount,
    TheFirendsTaFans,
    TheFriendsBePraise,//被赞
    TheFriendsBeCollected//被收藏
    
};

@interface YWFansViewController : UIViewController
@property(nonatomic,assign)TheFriends whichFriend;
@property(nonatomic,assign)NSInteger other_uid;

@end

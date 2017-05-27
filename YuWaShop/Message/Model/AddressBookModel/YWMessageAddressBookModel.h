//
//  YWMessageAddressBookModel.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMessageAddressBookModel : NSObject

@property (nonatomic,copy)NSString * user_id;
@property (nonatomic,copy)NSString * hxID;//环信账号（即为账号）
@property (nonatomic,copy)NSString * nikeName;//昵称
@property (nonatomic,copy)NSString * header_img;//头像

@end

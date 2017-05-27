//
//  RBPublishSession.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBPublishSession : NSObject

@property (nonatomic,copy)NSString * name;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString * con;
@property (nonatomic,copy)NSString * location;

+ (instancetype)sharePublishSession;

+ (void)clearPublish;

@end

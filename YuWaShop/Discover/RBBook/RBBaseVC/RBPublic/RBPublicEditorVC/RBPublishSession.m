//
//  RBPublishSession.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBPublishSession.h"

@implementation RBPublishSession

static RBPublishSession * publish = nil;

+ (RBPublishSession*)sharePublishSession{
    if (!publish) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            publish=[[RBPublishSession alloc]init];
        });
        publish.name= @"";
        publish.con = @"";
        publish.location = @"";
    }
    
    return publish;
}

+ (void)clearPublish{
    publish.name= @"";
    publish.con = @"";
    publish.location = @"";
    publish.status = 0;
}

@end

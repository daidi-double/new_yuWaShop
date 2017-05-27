//
//  RBNodeTagModel.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBNodeTagModel.h"

@implementation RBNodeTagModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"tagArr" : [RBPublicTagSaveModel class]};
}

@end

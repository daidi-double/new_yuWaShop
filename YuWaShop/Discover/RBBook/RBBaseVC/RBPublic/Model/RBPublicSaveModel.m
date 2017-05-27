//
//  RBPublicSaveModel.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBPublicSaveModel.h"

@implementation RBPublicSaveModel

- (void)setTagArr:(NSMutableArray<RBPublicTagSaveModel *> *)tagArr{
    if (!tagArr || tagArr.count <= 0)return;
    NSMutableArray * arrTemp = [NSMutableArray arrayWithCapacity:0];
    for (XHTagView * tagView in tagArr) {
        [arrTemp addObject:[[RBPublicTagSaveModel alloc]initWithTagView:tagView]];
    }
    _tagArr = [NSMutableArray arrayWithArray:arrTemp];
}

@end

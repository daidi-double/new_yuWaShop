//
//  XHBranchPoint.m
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import "XHBranchPoint.h"

@implementation XHBranchPoint

+ (instancetype)initlizerStartPoint:(CGPoint)startPoint midPoint:(CGPoint)midPoint endPoint:(CGPoint)endPoint direction:(XHBranchLayerDirection)direction {
    XHBranchPoint *branchPoint = [[XHBranchPoint alloc] init];
    branchPoint.startPoint = startPoint;
    branchPoint.midPoint = midPoint;
    branchPoint.endPoint = endPoint;
    branchPoint.direction = direction;
    return branchPoint;
}

@end

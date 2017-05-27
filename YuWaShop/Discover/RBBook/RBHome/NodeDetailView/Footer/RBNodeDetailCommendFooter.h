//
//  RBNodeDetailCommendFooter.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/13.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBNodeDetailCommendFooter : UIView

@property (nonatomic,copy)void (^viewAllCommentBlock)();
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic,copy)NSString * commentCount;


@end

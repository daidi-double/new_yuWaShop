//
//  RBNodeDetailTableViewCell.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBNodeShowModel.h"

@interface RBNodeDetailTableViewCell : UITableViewCell

//@property (nonatomic,copy)void (^likerShowBlock)();
//@property (nonatomic,copy)void (^collecterShowBlock)();
@property (nonatomic,strong)RBNodeShowModel * model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conLabelHeight;


//刷新数量(暂时无用)
- (void)refreshCollectionCountWithAdd:(BOOL)isAdd;
- (void)refreshLikesCountWithAdd:(BOOL)isAdd;

@end

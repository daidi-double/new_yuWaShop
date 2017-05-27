//
//  CommentTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CommentTableViewCellDelegate<NSObject>
@optional
- (void)changCellHeight:(NSInteger)staus;


@end
@class ShopdetailModel;

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,assign)id <CommentTableViewCellDelegate>cellDelegate;

-(void)giveValueWithModel:(ShopdetailModel*)model;
+(CGFloat)getCellHeight:(ShopdetailModel*)model;

@end

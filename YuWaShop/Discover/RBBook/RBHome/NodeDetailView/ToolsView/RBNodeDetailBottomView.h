//
//  RBNodeDetailBottomView.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBNodeDetailBottomView : UIView

@property (nonatomic,copy)void (^likeBlock)(BOOL);
@property (nonatomic,copy)void (^collectionBlock)(BOOL);
@property (nonatomic,copy)void (^commentBlock)();

@property (nonatomic,assign)BOOL isLike;
@property (nonatomic,assign)BOOL isCollection;
@property (nonatomic,copy)NSString * nodeID;
@property (nonatomic,copy)NSString * auser_type;//作者的type
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;//赞
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showLikeImageView;



@end

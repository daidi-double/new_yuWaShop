//
//  RBNodeDetailBottomView.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailBottomView.h"
#import "HttpObject.h"
#import "JWTools.h"
@implementation RBNodeDetailBottomView

- (void)setIsCollection:(BOOL)isCollection{
    if (_isCollection == isCollection)return;
    _isCollection = isCollection;
    [self.collectionBtn setTitle:isCollection == YES?@"已收藏":@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setImage:[UIImage imageNamed:isCollection == YES?@"":@"star"] forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:[UIColor colorWithHexString:isCollection == YES?@"#585858":@"#ffffff"] forState:UIControlStateNormal];
    self.collectionBtn.backgroundColor = [UIColor colorWithHexString:isCollection == YES?@"#ffffff":@"#3CCAED"];
}

- (void)setIsLike:(BOOL)isLike{
    if (_isLike == isLike)return;
    _isLike = isLike;
    [self.likeBtn setImage:[UIImage imageNamed:_isLike == YES?@"icon-like":@"icon-dislike"] forState:UIControlStateNormal];
}

- (void)likeBtnImageAnimation{
    CGPoint center = CGPointMake(self.likeBtn.x + self.likeBtn.imageView.width/2 + self.likeBtn.imageView.x, self.likeBtn.center.y);
    MyLog(@"like%d",_isLike);
    self.showLikeImageView.image = [UIImage imageNamed:_isLike?@"icon-like":@"icon-dislike"];
    self.showLikeImageView.alpha = 0.f;
    self.showLikeImageView.frame = CGRectMake(center.x - 1.f, center.y - 1.f, 2.f, 2.f);
    self.showLikeImageView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.showLikeImageView.frame = CGRectMake(center.x - 16.f, center.y - 16.f, 32.f, 32.f);
        self.showLikeImageView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.showLikeImageView.frame = CGRectMake(center.x - 6.f, center.y - 6.f, 12.f, 12.f);
            self.showLikeImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.showLikeImageView.hidden = YES;
        }];
    }];
}

- (IBAction)likeBtnAction:(id)sender {
    if (![UserSession instance].isLogin) {
        self.likeBlock(_isLike);
        return;
    }
    WEAKSELF;
    self.isLike = !_isLike;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf requestLike];
    }); 
    [self.likeBtn setImage:[UIImage imageNamed:_isLike == YES?@"icon-like":@"icon-dislike"] forState:UIControlStateNormal];
    [self likeBtnImageAnimation];
    self.likeBlock(_isLike);
}
- (IBAction)commentBtnAction:(id)sender {
    self.commentBlock();
}

- (IBAction)collectionAction:(id)sender {
    self.collectionBlock(_isCollection);
}

#pragma mark - Http
- (void)requestLike{
    if (!self.isLike) {
        [self requestCancelLike];
        return;
    }
    NSDictionary * pragram = @{@"note_id":self.nodeID,@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1),@"auser_type":self.auser_type};
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_LIKE withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

- (void)requestCancelLike{
    NSDictionary * pragram = @{@"note_id":self.nodeID,@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1),@"auser_type":self.auser_type};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_LIKE_CANCEL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}


@end

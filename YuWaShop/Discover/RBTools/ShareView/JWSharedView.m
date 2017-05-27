//
//  JWSharedView.m
//  Maldives
//
//  Created by Tian Wei You on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWSharedView.h"

@implementation JWSharedView
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.frame = CGRectMake(0.f, 0.f, kScreen_Width, kScreen_Height);
//        
//        self.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.2f];
//        
//        //移除手势
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
//        [tap addTarget:self action:@selector(tapShareViewAction)];
//        
//        [self makeCancelLabel];
//        [self addGestureRecognizer:tap];
//        
//        [self makeShareBtnView];
//        
//    }
//    return self;
//}
//- (void)makeCancelLabel{
//    UILabel * cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, kScreen_Height - 50.f, kScreen_Width - 20.f, 45.f)];
//    cancelLabel.backgroundColor = [UIColor whiteColor];
//    cancelLabel.layer.cornerRadius = 6.f;
//    cancelLabel.layer.masksToBounds = YES;
//    cancelLabel.textColor = [UIColor colorWithHexString:@"#519bf4"];
//    cancelLabel.font = [UIFont systemFontOfSize:20.f];
//    cancelLabel.textAlignment = NSTextAlignmentCenter;
//    cancelLabel.text =@"取消";
//    
//    [self addSubview:cancelLabel];
//}
//
//- (void)makeShareBtnView{
//    UIView * shareBtnView = [[UIView alloc]initWithFrame:CGRectMake(10.f, kScreen_Height - 260.f, kScreen_Width - 20.f, 205.f)];
//    shareBtnView.backgroundColor = [UIColor whiteColor];
//    shareBtnView.layer.cornerRadius = 6.f;
//    shareBtnView.layer.masksToBounds = YES;
//    
//    NSArray * imgArr = @[@"share-icon-WeChat",@"share-icon-friends",@"Micro-blog-Sina",@"share-icon-QQ"];
//    NSArray * conArr = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ"];
//    NSArray * tagArr = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeQZone)];
//    
//    CGFloat btnWidth = 60.f;
//    CGFloat btnY = 15.f;
//    CGFloat btnX = (kScreen_Width - 180.f)/4 - 10.f;
//    CGFloat btnEndge = (kScreen_Width - 180.f)/4 + btnWidth;
//    
//    CGFloat labelWidth = 80.f;
//    CGFloat labelHeigh = 20.f;
//    
//    for (int i = 0; i < imgArr.count; i++) {
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnWidth)];
//        [btn setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
//        btn.layer.cornerRadius = btnWidth/2;
//        btn.layer.masksToBounds = YES;
//        btn.tag = [tagArr[i] integerValue];
//        [btn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [shareBtnView addSubview:btn];
//        btnX += btnEndge;
//        
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, labelWidth, labelHeigh)];
//        label.center = CGPointMake(btn.center.x, CGRectGetMaxY(btn.frame) + 3.f + labelHeigh/2);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:13.f];
//        label.text = conArr[i];
//        [shareBtnView addSubview:label];
//        
//        if (i>=2) {
//            btnX = (kScreen_Width - 180.f)/4 - 10.f;
//            btnY += 5.f+CGRectGetMaxY(label.frame);
//        }
//    }
//    
//    
//    
//    [self addSubview:shareBtnView];
//}
//
//- (void)shareBtnAction:(UIButton *)sender{
//    [self removeFromSuperview];
//    self.shareClickBlock(sender.tag);
//}
//
//- (void)tapShareViewAction{
//    [self removeFromSuperview];
//}

@end

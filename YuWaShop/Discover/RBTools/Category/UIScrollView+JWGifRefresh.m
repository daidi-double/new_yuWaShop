//
//  UIScrollView+JWGifRefresh.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "UIScrollView+JWGifRefresh.h"

@implementation UIScrollView (JWGifRefresh)

/**
 *  下拉刷新动画
 *  @param imageName  图片名
 *  @param imageCount 图片数量
 *
 *  @return 刷新Header
 */
+ (MJRefreshGifHeader *)scrollRefreshGifHeaderWithImgName:(NSString *)imageName withImageCount:(NSInteger)imageCount withRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock{
    MJRefreshGifHeader * gifHeader = [[MJRefreshGifHeader alloc]init];
    gifHeader.refreshingBlock = refreshBlock;
    gifHeader.lastUpdatedTimeLabel.hidden= YES;
    gifHeader.stateLabel.hidden = YES;
    NSMutableArray * headerImagesIdle = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * headerImagesPulling = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * headerImagesRefreshing = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < imageCount; i++) {
        if (i<18) {
            [headerImagesIdle addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }else if (i<38){
            [headerImagesPulling addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }else {
            [headerImagesRefreshing addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }
    }
    [gifHeader setImages:headerImagesIdle duration:(headerImagesIdle.count*0.05) forState:MJRefreshStateIdle];
    [gifHeader setImages:headerImagesPulling duration:(headerImagesPulling.count*0.05) forState:MJRefreshStatePulling];
    [gifHeader setImages:headerImagesRefreshing duration:(headerImagesRefreshing.count*0.05) forState:MJRefreshStateRefreshing];
    return gifHeader;
}


/**
 *  上拉刷新动画
 *  @param imageName  图片名
 *  @param imageCount 图片数量
 *
 *  @return 刷新Header
 */
+ (MJRefreshAutoGifFooter *)scrollRefreshGifFooterWithImgName:(NSString *)imageName withImageCount:(NSInteger)imageCount withRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock{
    MJRefreshAutoGifFooter * gifFooter = [[MJRefreshAutoGifFooter alloc]init];
    gifFooter.refreshingBlock = refreshBlock;
    gifFooter.stateLabel.hidden = YES;
    gifFooter.refreshingTitleHidden = YES;
    NSMutableArray * footerImagesIdle = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * footerImagesPulling = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * footerImagesRefreshing = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < imageCount; i++) {
        if (i>=16) {
            [footerImagesRefreshing addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }
    }
    for (int i = 14; i >= 0; i--) {
        if (i < 8||i>10) {
            [footerImagesRefreshing addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%zi",imageName,i]]];
        }
    }
    [gifFooter setImages:footerImagesIdle duration:(footerImagesIdle.count*0.05) forState:MJRefreshStateIdle];
    [gifFooter setImages:footerImagesPulling duration:(footerImagesPulling.count*0.05) forState:MJRefreshStatePulling];
    [gifFooter setImages:footerImagesRefreshing duration:(footerImagesRefreshing.count*0.05) forState:MJRefreshStateRefreshing];
    return gifFooter;
}

@end

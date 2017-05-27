//
//  UIScrollView+JWGifRefresh.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UIScrollView (JWGifRefresh)

/**
 *  下拉刷新动画
 *  @param imageName  图片名
 *  @param imageCount 图片数量
 *
 *  @return 刷新Header
 */
+ (MJRefreshGifHeader *)scrollRefreshGifHeaderWithImgName:(NSString *)imageName withImageCount:(NSInteger)imageCount withRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock;


/**
 *  上拉刷新动画
 *  @param imageName  图片名
 *  @param imageCount 图片数量
 *
 *  @return 刷新Header
 */
+ (MJRefreshAutoGifFooter *)scrollRefreshGifFooterWithImgName:(NSString *)imageName withImageCount:(NSInteger)imageCount withRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock;

@end

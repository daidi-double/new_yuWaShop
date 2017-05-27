//
//  UIScrollView+MJRefreshGif.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/10/31.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "UIScrollView+MJRefreshGif.h"

@implementation UIScrollView (MJRefreshGif)

+(MJRefreshGifHeader*)scrollRefreshGifHeaderwithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock{
    MJRefreshGifHeader*gifHeader=[[MJRefreshGifHeader alloc]init];
    gifHeader.refreshingBlock=refreshBlock;
    gifHeader.lastUpdatedTimeLabel.hidden= YES;
    gifHeader.stateLabel.hidden = YES;
    gifHeader.backgroundColor=RGBCOLOR(240, 239, 237, 1);

     [UIScrollView setHeaderGIF:gifHeader WithImageName:@"下拉刷新_000" withImageCount:23 withPullWay:MJRefreshStateIdle];
//     [UIScrollView setHeaderGIF:gifHeader WithImageName:@"下拉刷新_000" withImageCount:20 withPullWay:MJRefreshStateRefreshing];
     [UIScrollView setHeaderGIF:gifHeader WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStatePulling];
    [UIScrollView setHeaderGIF:gifHeader WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateRefreshing];
    [UIScrollView setHeaderGIF:gifHeader WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateWillRefresh];
    [UIScrollView setHeaderGIF:gifHeader WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateNoMoreData];

    
//  MJRefreshStatePulling     MJRefreshStateWillRefresh  MJRefreshStateNoMoreData
     return gifHeader;
    
}

+(void)setHeaderGIF:(MJRefreshGifHeader*)header WithImageName:(NSString*)imageName withImageCount:(NSInteger)imageCount withPullWay:(MJRefreshState)Brefresh{
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 0; i<imageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imageName,i]];
        [idleImages addObject:image];
    }
    
      [header setImages:idleImages forState:Brefresh];
    
    
}


+(MJRefreshAutoGifFooter*)scrollRefreshGifFooterWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshBlock{
        MJRefreshAutoGifFooter * gifFooter = [[MJRefreshAutoGifFooter alloc]init];
        gifFooter.refreshingBlock = refreshBlock;
        gifFooter.stateLabel.hidden = YES;
        gifFooter.refreshingTitleHidden = YES;
       gifFooter.backgroundColor=RGBCOLOR(240, 239, 237, 1);
    
//    [UIScrollView setFooterGIF:gifFooter WithImageName:@"下拉刷新_0000" withImageCount:18 withPullWay:MJRefreshStateIdle];
////    [UIScrollView setFooterGIF:gifFooter WithImageName:@"下拉刷新_000" withImageCount:20 withPullWay:MJRefreshStatePulling];
//    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStatePulling];
//    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateRefreshing];
//    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateWillRefresh];
//    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateNoMoreData];
    
    [UIScrollView setFooterGIF:gifFooter WithImageName:@"下拉刷新_000" withImageCount:23 withPullWay:MJRefreshStateIdle];
    //     [UIScrollView setHeaderGIF:gifHeader WithImageName:@"下拉刷新_000" withImageCount:20 withPullWay:MJRefreshStateRefreshing];
    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStatePulling];
    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateRefreshing];
    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateWillRefresh];
    [UIScrollView setFooterGIF:gifFooter WithImageName:@"发光_00" withImageCount:22 withPullWay:MJRefreshStateNoMoreData];

    
    
    return gifFooter;
}

+(void)setFooterGIF:(MJRefreshAutoGifFooter*)footer WithImageName:(NSString*)imageName withImageCount:(NSInteger)imageCount withPullWay:(MJRefreshState)Brefresh{
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 0; i<imageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",imageName,i]];
        [idleImages addObject:image];
    }
    
    [footer setImages:idleImages forState:Brefresh];

    
}




@end

//
//  JLScrollView.h
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//  展示放大图片的滑动视图

#import <UIKit/UIKit.h>
#import "JLPhoto.h"
#import "StorePhotoModel.h"

@interface JLPhotoBrowser : UIView

@property (nonatomic,copy)void (^showBlock)();

/**
 *  存放图片的数组
 */
@property (nonatomic,strong) NSArray *photos;
/**
 *  当前的index
 */
@property (nonatomic,assign) int currentIndex;

/**
 * 存放所有的数据
 */
@property(nonatomic,strong)NSMutableArray*allDatasModel;

/**
 *  显示图片浏览器
 */
-(void)show;


//两个回调 用来删除照片和修改照片名字的
@property(nonatomic,strong)void(^changeNameBlock)(NSInteger selectedNumber,NSString*title);
@property(nonatomic,strong)void(^deletePhotoBlock)(NSInteger selectedNumber);


@end

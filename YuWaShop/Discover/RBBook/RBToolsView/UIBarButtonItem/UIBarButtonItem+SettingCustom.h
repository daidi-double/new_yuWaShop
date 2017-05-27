//
//  UIBarButtonItem+SettingCustom.h
//  JW百思
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SettingCustom)

#pragma mark - UIBarButtonItemSetting
/**
 *  设置UIBarButtonItem（只有图片）
 *
 *  @param imageName   imageName
 *  @param selectImage selectImage
 *  @param alignment   控件水平方向靠拢模式
 *  @param target       UIBarButtonItem添加点击事件target
 *  @param action       UIBarButtonItem添加点击事件action
 *  @param controlEvent UIBarButtonItem添加点击事件controlEvent
 *
 *  @return 自定义的barButtonItem
 */

+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent  withWidth:(CGFloat)width;

/**
 *  设置UIBarButtonItem（图片&文字）
 *
 *  @param imageName   imageName
 *  @param selectImage selectImage
 *  @param alignment   控件水平方向靠拢模式
 *  @param itemTittle   item文本
 *  @param tittleColor  item文字颜色
 *  @param target       UIBarButtonItem添加点击事件
 *  @param action       UIBarButtonItem添加点击事件
 *  @param controlEvent UIBarButtonItem添加点击事件9
 *
 *  @return 自定义的barButtonItem
 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTittle:(NSString *)itemTittle withTittleColor:(UIColor *)tittleColor withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent withWidth:(CGFloat)width;
/**
 *  设置UIBarButtonItem（带边框的图片&文字）
 *
 *  @param imageName   imageName
 *  @param selectImage selectImage
 *  @param alignment   控件水平方向靠拢模式
 *  @param itemTittle   item文本
 *  @param tittleColor  item文字颜色
 *  @param target       UIBarButtonItem添加点击事件
 *  @param action       UIBarButtonItem添加点击事件
 *  @param controlEvent UIBarButtonItem添加点击事件9
 *
 *  @return 自定义的barButtonItem
 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTittle:(NSString *)itemTittle withTittleColor:(UIColor *)tittleColor withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent withWidth:(CGFloat)width withBorderColor:(UIColor *)borderColor;
/**
 *  设置UIBarButtonItem（只有图片,自定义大小）
 *
 *  @param imageName   imageName
 *  @param selectImage selectImage
 *  @param alignment   控件水平方向靠拢模式
 *  @param target       UIBarButtonItem添加点击事件
 *  @param action       UIBarButtonItem添加点击事件
 *  @param controlEvent UIBarButtonItem添加点击事件9
 *  @param size         barButton的大小
 *  @return 自定义的barButtonItem
 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent withSize:(CGSize)size;

#pragma mark - PropertySetting
/**
 *  修改UIBarButtonItem文字颜色
 *
 *  @param color 文本颜色
 *
 *  @return 修改是否成功
 */
- (BOOL)setBarItemWithColor:(UIColor *)color;


@end

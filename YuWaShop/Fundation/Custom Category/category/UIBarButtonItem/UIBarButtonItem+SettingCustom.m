//
//  UIBarButtonItem+SettingCustom.m
//  JW百思
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "UIBarButtonItem+SettingCustom.h"

@implementation UIBarButtonItem (SettingCustom)

#pragma mark - UIBarButtonItemSetting

/**
 *  设置UIBarButtonItem（只有图片）
 *
 *  @param imageName   imageName
 *  @param selectImage selectImage
 *  @param alignment   控件水平方向靠拢模式
 *  @param target       UIBarButtonItem添加点击事件
 *  @param action       UIBarButtonItem添加点击事件
 *  @param controlEvent UIBarButtonItem添加点击事件9
 *
 *  @return 自定义的barButtonItem
 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent  withWidth:(CGFloat)width{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 0.f, width, 30.f);
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selectImage) {
        [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    }
    btn.contentHorizontalAlignment = alignment;
    
    [btn addTarget:target action:action forControlEvents:controlEvent];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    btn.tag = 1;
    return item;
}

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
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTittle:(NSString *)itemTittle withTittleColor:(UIColor *)tittleColor withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent withWidth:(CGFloat)width{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 0.f, width, 30.f);
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selectImage) {
        [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    }
    [btn setTitle:itemTittle forState:UIControlStateNormal];
    [btn setTitleColor:tittleColor forState:UIControlStateNormal];
    
    btn.contentHorizontalAlignment = alignment;
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn addTarget:target action:action forControlEvents:controlEvent];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [item setBarItemWithColor:tittleColor];
    btn.tag = 1;
    return item;
}

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
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTittle:(NSString *)itemTittle withTittleColor:(UIColor *)tittleColor withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent withWidth:(CGFloat)width withBorderColor:(UIColor *)borderColor{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 0.f, width, 24.f);
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selectImage) {
        [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    }
    if (borderColor) {
        btn.layer.borderColor = borderColor.CGColor;
        btn.layer.borderWidth = 1.5f;
        btn.layer.cornerRadius = 12.f;
        btn.layer.masksToBounds = YES;
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn setTitle:itemTittle forState:UIControlStateNormal];
    [btn setTitleColor:tittleColor forState:UIControlStateNormal];
    
    btn.contentHorizontalAlignment = alignment;
    
    [btn addTarget:target action:action forControlEvents:controlEvent];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [item setBarItemWithColor:tittleColor];
    btn.tag = 1;
    return item;
}

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
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName withSelectImage:(NSString *)selectImage withHorizontalAlignment:(UIControlContentHorizontalAlignment)alignment withTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent withSize:(CGSize)size{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0.f, 0.f, size.width, size.height);
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selectImage) {
        [btn setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    }
    
    btn.contentHorizontalAlignment = alignment;
    
    [btn addTarget:target action:action forControlEvents:controlEvent];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    btn.tag = 1;
    return item;
}
#pragma mark - PropertySetting
/**
 *  修改UIBarButtonItem文字颜色
 *
 *  @param color 文本颜色
 *
 *  @return 修改是否成功
 */
- (BOOL)setBarItemWithColor:(UIColor *)color{
    NSDictionary * attributes = @{NSForegroundColorAttributeName:color};
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    return YES;
}


@end

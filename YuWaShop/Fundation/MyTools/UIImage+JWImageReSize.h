//
//  UIImage+JWImageReSize.h
//  JWQQChat
//
//  Created by scjy on 16/4/17.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JWImageReSize)

/**
 *  拉伸图片
 *
 *  @param selectImage 要拉伸的图片
 *
 *  @return 拉伸后图片
 */
/**
 iOS中有个叫端盖(end cap)的概念，用来指定图片中的哪一部分不用拉伸。中间空缺的代表需要被拉伸的矩形区域，上下左右不需要被拉伸的边缘就称为端盖
 iOS 5.0
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets
 iOS 6.0
 这个方法只接收一个UIEdgeInsets类型的参数，可以通过设置UIEdgeInsets的left、right、top、bottom来分别指定左端盖宽度、右端盖宽度、顶端盖高度、底端盖高度
 
 - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode
 对比iOS5.0中的方法，只多了一个UIImageResizingMode参数，用来指定拉伸的模式：
 UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
 UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
 */
- (UIImage *)resizableImageWithImage;

@end

//
//  JWThirdTools.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JWThirdTools : NSObject

/**
 *  计算单个文件大小
 *
 *  @param path 路径
 *
 *  @return 大小
 */
+ (CGFloat)fileSizeAtPath:(NSString *)path;
/**
 *  计算目录大小
 *
 *  @param path 路径
 *
 *  @return 大小
 */
+ (CGFloat)folderSizeAtPath:(NSString *)path;
/**
 *  清理缓存文件
 *
 *  @param path 路径
 */
+(void)clearCache:(NSString *)path;




@end

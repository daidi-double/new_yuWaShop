//
//  NSString+JWAppendOtherStr.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JWAppendOtherStr)

/**
 *  Str多彩拼接
 *
 *  @param firstStr    str
 *  @param firstFont   font
 *  @param firstColor  color
 *  @param secondStr   str
 *  @param secondFont  font
 *  @param secondColor color
 *
 *  @return NSMutableAttributedString 以attributedText承接
 */
+ (NSMutableAttributedString *)stringWithFirstStr:(NSString *)firstStr withFont:(UIFont *)firstFont withColor:(UIColor *)firstColor withSecondtStr:(NSString *)secondStr withFont:(UIFont *)secondFont withColor:(UIColor *)secondColor;

/**
 *  Str多彩拼接画线
 *
 *  @param firstStr    str
 *  @param firstFont   font
 *  @param firstColor  color
 *  @param secondStr   str
 *  @param secondFont  font
 *  @param secondColor color
 *
 *  @return NSMutableAttributedString 以attributedText承接
 */
+ (NSMutableAttributedString *)stringWithFirstStr:(NSString *)firstStr withFont:(UIFont *)firstFont withColor:(UIColor *)firstColor withIsLine:(BOOL)firstLine withSecondtStr:(NSString *)secondStr withFont:(UIFont *)secondFont withColor:(UIColor *)secondColor withIsLine:(BOOL)secondLine;

@end

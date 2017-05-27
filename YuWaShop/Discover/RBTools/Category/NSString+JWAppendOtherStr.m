//
//  NSString+JWAppendOtherStr.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "NSString+JWAppendOtherStr.h"

@implementation NSString (JWAppendOtherStr)

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
+ (NSMutableAttributedString *)stringWithFirstStr:(NSString *)firstStr withFont:(UIFont *)firstFont withColor:(UIColor *)firstColor withSecondtStr:(NSString *)secondStr withFont:(UIFont *)secondFont withColor:(UIColor *)secondColor{
    NSMutableAttributedString *first=[[NSMutableAttributedString alloc]initWithString:firstStr attributes:@{NSForegroundColorAttributeName:firstColor,NSFontAttributeName:firstFont}];
    NSMutableAttributedString *second=[[NSMutableAttributedString alloc]initWithString:secondStr attributes:@{NSForegroundColorAttributeName:secondColor,NSFontAttributeName:secondFont}];
    //文字上 横线
//    [second addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, second.length)];
    [first appendAttributedString:second];
    
    return first;
}

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
+ (NSMutableAttributedString *)stringWithFirstStr:(NSString *)firstStr withFont:(UIFont *)firstFont withColor:(UIColor *)firstColor withIsLine:(BOOL)firstLine withSecondtStr:(NSString *)secondStr withFont:(UIFont *)secondFont withColor:(UIColor *)secondColor withIsLine:(BOOL)secondLine{
    NSMutableAttributedString *first=[[NSMutableAttributedString alloc]initWithString:firstStr attributes:@{NSForegroundColorAttributeName:firstColor,NSFontAttributeName:firstFont}];
    //文字上 横线
    if (firstLine) {
        [first addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, first.length)];
    }
    NSMutableAttributedString *second=[[NSMutableAttributedString alloc]initWithString:secondStr attributes:@{NSForegroundColorAttributeName:secondColor,NSFontAttributeName:secondFont}];
    //文字上 横线
    if (secondLine) {
        [second addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, second.length)];
    }
    [first appendAttributedString:second];
    
    return first;
}

@end

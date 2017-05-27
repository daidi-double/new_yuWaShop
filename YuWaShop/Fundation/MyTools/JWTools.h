//
//  JWTools.h
//  JW百思
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JWTools : NSObject

+ (CGFloat)labelHeightWithLabel:(UILabel *)label;
+ (id)sortWithArray:(NSArray *)arr des:(BOOL)des;
+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size;
+ (CGFloat)labelHeightWithLabel:(UILabel *)label withWidth:(CGFloat)width;
+ (CGFloat)labelWidthWithLabel:(UILabel *)label;
+ (CGFloat)labelWidthWithLabel:(UILabel *)label withHeight:(CGFloat)height;
+ (NSDictionary *)jsonWithFileName:(NSString *)fileName;
+ (NSString *)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type;
+ (NSString *)filePathWithFileName:(NSString *)fileName;
+ (NSString *)fileWithFileName:(NSString *)fileName;
+ (NSArray *)contentArrayForFileName:(NSString *)fileName;
+ (NSDictionary *)contentDictForFileName:(NSString *)fileName;
+ (NSString *)saveJImage:(UIImage *)image;
+ (NSString *)dateWithYearMonthDayStr:(NSString *)dateStr;
+ (NSString *)dateStr:(NSString *)dateStr;
+ (NSString *)dateWithStr:(NSString *)dateStr;
+ (NSString *)dateWithOutYearStr:(NSString *)dateStr;
+ (NSString *)dateWithOutYearDate:(NSDate *)date;
+ (NSString *)dateTimeWithStr:(NSString *)dateStr;
+ (NSString *)dateWithTodayYearMonthDayStr;
+ (NSString *)dateWithTodayYearMonthDayNumberStr;
+ (BOOL)firstDate:(NSString *)firstDateStr withCompareDate:(NSString *)compareDateStr;
+ (NSString *)jsonStrWithKey:(NSString *)key withArr:(NSArray *)arr;
+ (NSString *)jsonStrWithArr:(NSArray *)arr;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSString *)UTF8WithStringJW:(NSString *)str;
+ (NSString *)stringWithUTF8JW:(NSString *)UTF8String;
+ (BOOL)isRightPassWordWithStr:(NSString *)password;
+ (BOOL)isComfireCodeWithStr:(NSString *)comfireCode;
+ (BOOL)isNumberWithStr:(NSString *)numberStr;
+ (BOOL)isValidateMoney:(NSString *)numberStr;
+ (BOOL)isEmailWithStr:(NSString *)email;
+ (BOOL)isPhoneIDWithStr:(NSString *)phoneNumber;
+ (BOOL)checkTelNumber:(NSString*)telNumber;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSString *)stringNumberTurnToDateWithNumber:(NSString *)number;
+ (NSString *)stringWithFirstCharactor:(NSString *)str;
+ (NSString *)stringWithNumberThirtyTwoBase:(NSString *)str;
+ (NSString *)stringThirtyTwoWithNumberTenBase:(NSString *)numberStr;
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius;
+ (void)cornerRadiusUISet:(UIControl *)sender;
+ (UIImage *)makeQRCodeWithStr:(NSString *)QRStr;
+ (NSString *)imageToStr:(UIImage *)image;
+ (CGSize)getScaleImageSizeWithImageView:(UIImage *)image withHeight:(CGFloat)height withWidth:(CGFloat)width;
+ (UIImage*)imageByScalingAndCropping:(UIImage *)image ForSize:(CGSize)targetSize;
+ (UIImage *)zipImageWithImage:(UIImage *)image;
+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName;
+ (NSArray *)imageFilterArr;
+ (NSString *)getUUID;



//得到当前时间
+ (NSString*)currentTime;

/**
 时间戳
 
 */
+(NSString*)getTime:(NSString*)number;


/**
 有带小时和分的时间
 */
+(NSString*)getHourAndMinTime:(NSString*)detailNumber;

/*
 * 加上loading图
 
 */
+(UIView*)addLoadingViewWithframe:(CGRect)frame;

/*
 *移除loading图
 */
+(void)removeLoadingView:(UIView*)view;

/*
 *显示
 */
+(UIView*)addFailViewWithFrame:(CGRect)frame withTouchBlock:(void(^)())touchBlock;

@end

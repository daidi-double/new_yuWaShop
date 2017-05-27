//
//  JWTools.m
//  JW百思
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "JWTools.h"
#import <CoreImage/CoreImage.h>

#import "HUDFailureShowView.h"

@implementation JWTools

+ (id)sortWithArray:(NSArray *)arr des:(BOOL)des{
    NSMutableArray *resultArr = [arr mutableCopy];
    [resultArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (des) {
            return obj1 > obj2;
        }else{
            return obj1 < obj2;
        }
    }];
    return [resultArr mutableCopy];
}
+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size;
}
+ (CGFloat)labelHeightWithLabel:(UILabel *)label{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return conRect.size.height + 5.f;
}
+ (CGFloat)labelHeightWithLabel:(UILabel *)label withWidth:(CGFloat)width{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return conRect.size.height;
}
+ (CGFloat)labelWidthWithLabel:(UILabel *)label{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT,label.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return conRect.size.width + 5.f;
}
+ (CGFloat)labelWidthWithLabel:(UILabel *)label withHeight:(CGFloat)height{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return conRect.size.width;
}
+ (NSDictionary *)jsonWithFileName:(NSString *)fileName{
    NSData * data = [[NSData alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"json"]];
    NSError*error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return (NSDictionary *)jsonObject;
}
+ (NSString *)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray * urlsArray = [fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * pathURL = [urlsArray firstObject];
    NSString * path = [pathURL path];
    NSString * filePath;
    filePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",fileName,type]];
    if (![fileManger fileExistsAtPath:filePath]) {
        [fileManger createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}
+ (NSString *)filePathWithFileName:(NSString *)fileName{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray * urlsArray = [fileManger URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL * pathURL = [urlsArray firstObject];
    NSString * path = [pathURL path];
    NSString * filePath;
    filePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    if (![fileManger fileExistsAtPath:filePath]) {
        [fileManger createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}
+ (NSString *)fileWithFileName:(NSString *)fileName{
    NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return file;
}
+ (NSArray *)contentArrayForFileName:(NSString *)fileName{
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:[self filePathWithFileName:fileName]];
    return dataArr;
}
+ (NSDictionary *)contentDictForFileName:(NSString *)fileName{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self filePathWithFileName:fileName]];
    return dict;
}
+ (NSString *)saveJImage:(UIImage *)image{
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate * date = [NSDate date];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString * imgPath = [NSString stringWithFormat:@"%@.png",[dateFormatter stringFromDate:date]];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString * imagePath = [NSString stringWithFormat:@"%@/%@",docs[0],imgPath];
    [imageData writeToFile:imagePath atomically:YES];
    return imgPath;
}
+ (NSString *)dateWithYearMonthDayStr:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]];
    }
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateWithTodayYearMonthDayStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate date];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateWithTodayYearMonthDayNumberStr{
    return [JWTools dateTimeWithStr:[JWTools dateWithTodayYearMonthDayStr]];
}
+ (NSString *)dateStr:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]];
    }
    if (!date) {
        return nil;
    }
    if ([calendar isDateInYesterday:date]) {
        dateFormatter.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
    }
    if ([calendar isDateInToday:date]) {
        dateFormatter.dateFormat = @"HH:mm:ss";
        return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
    }
    dateFormatter.dateFormat = @"MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateWithStr:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]];
    }
    if (!date)return nil;
    if ([calendar isDateInYesterday:date]) {
        dateFormatter.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
    }
    if ([calendar isDateInToday:date]) {
        dateFormatter.dateFormat = @"HH";
        NSInteger time = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]] integerValue];
        NSInteger timeNow = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]] integerValue];
        if (timeNow - time == 1){
            dateFormatter.dateFormat = @"mm";
            time = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]] integerValue];
            timeNow = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]] integerValue];
            if (timeNow - time >= 0) {
                return [NSString stringWithFormat:@"1小时前"];
            }else{
                return [NSString stringWithFormat:@"%zi分钟前",timeNow - time + 60];
            }
        }
        if (timeNow - time == 0) {
            dateFormatter.dateFormat = @"mm";
            time = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]] integerValue];
            timeNow = [[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]] integerValue];
            return [NSString stringWithFormat:@"%zi分钟前",timeNow - time];
        }
        if (timeNow - time< 0) {
            dateFormatter.dateFormat =@"HH:mm";
            return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:date]];
        }
//        return [NSString stringWithFormat:@"%zi小时前",timeNow - time];
    }
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateWithOutYearStr:(NSString *)dateStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]];
    }
    if (!date) {
        return nil;
    }
    if ([calendar isDateInToday:date]) {
        dateFormatter.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    }
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateWithOutYearDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if (!date) {
        return nil;
    }
    if ([calendar isDateInToday:date]) {
        dateFormatter.dateFormat = @"HH:mm";
        return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    }
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    return [dateFormatter stringFromDate:date];
}
+ (NSString *)dateTimeWithStr:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return [NSString stringWithFormat:@"%zi",((long long)[date timeIntervalSince1970])];
}
+ (BOOL)firstDate:(NSString *)firstDateStr withCompareDate:(NSString *)compareDateStr{
    return  [firstDateStr doubleValue] <= [compareDateStr doubleValue];
}
+ (NSString *)jsonStrWithKey:(NSString *)key withArr:(NSArray *)arr{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:arr forKey:key];
    NSData *data=[NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
+ (NSString *)jsonStrWithArr:(NSArray *)arr{
    NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (!jsonString)return nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+ (NSString *)UTF8WithStringJW:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSString *)stringWithUTF8JW:(NSString *)UTF8String{
    return [UTF8String stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (BOOL)isRightPassWordWithStr:(NSString *)password{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}
+ (BOOL)isComfireCodeWithStr:(NSString *)comfireCode{
    NSString *codeRegex = @"^[0-9]{1,10}+$";
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codePredicate evaluateWithObject:comfireCode];
}
+ (BOOL)isNumberWithStr:(NSString *)numberStr{
    NSString * numberRegex = @"^[0-9]{1,99}+$";
    NSPredicate * numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPredicate evaluateWithObject:numberStr];
}
+ (BOOL)isValidateMoney:(NSString *)numberStr{
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:numberStr];
}
+ (BOOL)isEmailWithStr:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)isPhoneIDWithStr:(NSString *)phoneNumber{
    NSString * phoneNumberRegex = @"^[0-9]{10,11}+$";
    NSPredicate * phoneNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumberRegex];
    return [phoneNumberPredicate evaluateWithObject:phoneNumber];
}
+ (BOOL)checkTelNumber:(NSString*)telNumber{
    NSString * pattern =@"^1+[3578]+\\d{9}";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [pred evaluateWithObject:telNumber];
}
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}
+ (NSString *)stringNumberTurnToDateWithNumber:(NSString *)number{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[number intValue]];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:confromTimesp]];
}
+ (NSString *)stringWithFirstCharactor:(NSString *)str{
    NSMutableString *strFir = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)strFir,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)strFir,NULL, kCFStringTransformStripDiacritics,NO);
    return [[strFir capitalizedString] substringToIndex:1];
}
+ (NSString *)stringWithNumberThirtyTwoBase:(NSString *)str{
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,32)];
    return temp10;
}
+ (NSString *)stringThirtyTwoWithNumberTenBase:(NSString *)numberStr{
    NSString *nLetterValue;
    NSString *str =@"";
    NSInteger tmpid = [numberStr integerValue];
    NSInteger ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig= tmpid%32;
        tmpid= tmpid/32;
        switch (ttmpig){
            case 10:
                nLetterValue =@"a";break;
            case 11:
                nLetterValue =@"b";break;
            case 12:
                nLetterValue =@"c";break;
            case 13:
                nLetterValue =@"d";break;
            case 14:
                nLetterValue =@"e";break;
            case 15:
                nLetterValue =@"f";break;
            case 16:
                nLetterValue =@"g";break;
            case 17:
                nLetterValue =@"h";break;
            case 18:
                nLetterValue =@"i";break;
            case 19:
                nLetterValue =@"j";break;
            case 20:
                nLetterValue =@"k";break;
            case 21:
                nLetterValue =@"l";break;
            case 22:
                nLetterValue =@"m";break;
            case 23:
                nLetterValue =@"n";break;
            case 24:
                nLetterValue =@"o";break;
            case 25:
                nLetterValue =@"p";break;
            case 26:
                nLetterValue =@"q";break;
            case 27:
                nLetterValue =@"r";break;
            case 28:
                nLetterValue =@"s";break;
            case 29:
                nLetterValue =@"t";break;
            case 30:
                nLetterValue =@"u";break;
            case 31:
                nLetterValue =@"v";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%zi",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {3,1};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, cornerRadius, 0.0);
    CGContextAddLineToPoint(context, size.width-cornerRadius, 0.0);
    CGContextAddLineToPoint(context, size.width, cornerRadius);
    CGContextAddLineToPoint(context, size.width, size.height-cornerRadius);
    CGContextAddLineToPoint(context, size.width - cornerRadius, size.height);
    CGContextAddLineToPoint(context, cornerRadius, size.height);
    CGContextAddLineToPoint(context, 0, size.height-cornerRadius);
    CGContextAddLineToPoint(context, 0.0, cornerRadius);
    CGContextAddLineToPoint(context, cornerRadius, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (void)cornerRadiusUISet:(UIControl *)sender{
    sender.layer.cornerRadius = 5.f;
    sender.layer.masksToBounds = YES;
}
+ (UIImage *)makeQRCodeWithStr:(NSString *)QRStr{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [QRStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputimage = [filter outputImage];
    return [JWTools createNonInterpolatedUIImageFormCIImage:outputimage withSize:100.f];
}
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (NSString *)imageToStr:(UIImage *)image{
    NSData * data = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
+ (CGSize)getScaleImageSizeWithImageView:(UIImage *)image withHeight:(CGFloat)height withWidth:(CGFloat)width{
    float heightScale = height/image.size.height/1.0;
    float widthScale = width/image.size.width/1.0;
    float scale = MIN(heightScale, widthScale);
    float h = image.size.height*scale;
    float w = image.size.width*scale;
    return CGSizeMake(w, h);
}
+ (UIImage*)imageByScalingAndCropping:(UIImage *)image ForSize:(CGSize)targetSize{
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+ (UIImage *)zipImageWithImage:(UIImage *)image{
    while (UIImageJPEGRepresentation(image, 1.f).length/1024 > 30) {
        image = [JWTools imageByScalingAndCropping:image ForSize:CGSizeMake(image.size.width * 0.7f, image.size.height * 0.7f)];
    }
    return image;
}
+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName{
    if([filterName isEqualToString:@"Original"])return image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return result;
}
+ (NSArray *)imageFilterArr{
    return @[@{@"name":@"Original",@"title":@"原图"},@{@"name":@"CISRGBToneCurveToLinear",@"title":@"挪威的森林"},@{@"name":@"CIPhotoEffectChrome",@"title":@"迷失京东"},@{@"name":@"CIPhotoEffectInstant",@"title":@"一页台北"},@{@"name":@"CIPhotoEffectProcess",@"title":@"罗马假日"},@{@"name":@"CIPhotoEffectTransfer",@"title":@"恋战冲绳"},@{@"name":@"CISepiaTone",@"title":@"情迷翡冷翠"},@{@"name":@"CILinearToSRGBToneCurve",@"title":@"布拉格之恋"},@{@"name":@"CIPhotoEffectFade",@"title":@"旺角卡门"},@{@"name":@"CIPhotoEffectNoir",@"title":@"挪威风情"},@{@"name":@"CIPhotoEffectMono",@"title":@"广岛之恋"},@{@"name":@"CIPhotoEffectTonal",@"title":@"冰岛之梦"}];
}
+(NSString *)getUUID{
    NSString * strUUID = [KUSERDEFAULT valueForKey:KEY_USERNAME_PASSWORD];
    if (strUUID)return strUUID;
    strUUID = (NSString *)[JWTools load:@"com.company.app.usernamepassword"];
    if ([strUUID isEqualToString:@""] || !strUUID){
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        [JWTools save:KEY_USERNAME_PASSWORD data:strUUID];
        [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:KEY_USERNAME_PASSWORD];
    }
    return strUUID;
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}
+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}



+(NSString*)getTime:(NSString *)number{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    @"yyyy-MM-dd HH:mm"
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFormatter dateFromString:number];
    
    
    if (!date) {
        date = [NSDate dateWithTimeIntervalSince1970:[number doubleValue]];
    }

    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
    
}

+(NSString*)getHourAndMinTime:(NSString*)detailNumber{
//    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//    [dateFormatter setTimeZone:timeZone];
//    NSDate*date=[dateFormatter dateFromString:detailNumber];
//    if (!date) {
//
//        date=[NSDate dateWithTimeIntervalSinceNow:[detailNumber doubleValue]];
//        MyLog(@"dateFormatter = %@",date);
//    }
    

//    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[detailNumber doubleValue]];
   
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;

}


+(UIView*)addLoadingViewWithframe:(CGRect)frame{
    UIView*loadingView=[[NSBundle mainBundle]loadNibNamed:@"HUDLoadingShowView" owner:nil options:nil].firstObject;
    loadingView.frame=frame;
     return loadingView;
}

+(void)removeLoadingView:(UIView*)view{
    [view removeFromSuperview];
    
}

+(UIView*)addFailViewWithFrame:(CGRect)frame withTouchBlock:(void (^)())touchBlock{
    HUDFailureShowView*failView=[[NSBundle mainBundle]loadNibNamed:@"HUDFailureShowView" owner:nil options:nil].firstObject;
    failView.frame=CGRectMake(0, 64, kScreen_Width, kScreen_Height-64);
    failView.reloadBlock=touchBlock;
  
    
    return failView;
}

//得到当前的时间
+(NSString*)currentTime{
    NSDate*current=[NSDate date];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //   hh:mm:ss
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString*strTime=[dateFormatter stringFromDate:current];
    
    return strTime;
}



@end

//
//  NSArray+Log.m
//  HomeWork2
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

/**
 *  解决NSArray输出中文乱码
 */
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}



@end

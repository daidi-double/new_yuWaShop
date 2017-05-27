//
//  NSDictionary+Log.m
//  JWXer
//
//  Created by scjy on 16/2/20.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)


/**
 *  解决NSDictionary输出中文乱码
 */
- (NSString *)descriptionWithLocale:(id)locale{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    
    [str appendString:@"}"];
    
    return str;
}

@end

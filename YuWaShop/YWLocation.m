//
//  YWLocation.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWLocation.h"

@implementation YWLocation
static YWLocation * location = nil;

+ (instancetype)shareLocation{
    
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [super allocWithZone:zone];
        [YWLocation getDataFromDefault];
    });
    return location;
    
    
}



+ (void)saveLat:(CGFloat)lat{
    [KUSERDEFAULT setObject:[NSString stringWithFormat:@"%f",lat] forKey:LOCATION_LAT];
    location.coordinate = (CLLocationCoordinate2D){lat,location.lon};
}
+ (void)saveLon:(CGFloat)lon{
    [KUSERDEFAULT setObject:[NSString stringWithFormat:@"%f",lon] forKey:LOCATION_LON];
    location.coordinate = (CLLocationCoordinate2D){location.lat,lon};
}

+ (void)getDataFromDefault{
    NSString * location_lonDefault = [KUSERDEFAULT valueForKey:LOCATION_LON];
    NSString * location_latDefault = [KUSERDEFAULT valueForKey:LOCATION_LAT];
    if (!location_latDefault) {
        location.lat = 24.88f;
        location.lon = 118.67f;
        location.coordinate = (CLLocationCoordinate2D){location.lat,location.lon};
        return;
    }
    location.lat = [location_latDefault floatValue];
    location.lon = [location_lonDefault floatValue];
    location.coordinate = (CLLocationCoordinate2D){location.lat,location.lon};
}

+ (void)saveLocationInfoWithLat:(CGFloat)lat withLon:(CGFloat)lon{
    [KUSERDEFAULT setObject:[NSString stringWithFormat:@"%f",lat] forKey:LOCATION_LAT];
    [KUSERDEFAULT setObject:[NSString stringWithFormat:@"%f",lon] forKey:LOCATION_LON];
}

@end

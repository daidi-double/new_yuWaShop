//
//  JWLocationBasicViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWLocationBasicViewController.h"

@interface JWLocationBasicViewController ()

@end

@implementation JWLocationBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    self.location = [YWLocation shareLocation];
    // 开始定位
    [self.loctionManger requestAlwaysAuthorization];
    [self.loctionManger startUpdatingLocation];
}

- (CLLocationManager *)loctionManger{
    if (!_loctionManger) {
        _loctionManger = [[CLLocationManager alloc] init];
        _loctionManger.delegate = self;
        // 设置定位精确度到米
        _loctionManger.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        _loctionManger.distanceFilter = kCLDistanceFilterNone;
        
    }
    return _loctionManger;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways||status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}

@end

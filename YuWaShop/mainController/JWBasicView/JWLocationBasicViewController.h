//
//  JWLocationBasicViewController.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWBasicViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface JWLocationBasicViewController : JWBasicViewController<CLLocationManagerDelegate>

@property (nonatomic,strong)YWLocation * location;

@property(nonatomic, strong)CLLocationManager * loctionManger;

@end

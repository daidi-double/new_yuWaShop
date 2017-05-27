//
//  YWStormPinAnnotationView.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "YWStormAnnotationModel.h"

@interface YWStormPinAnnotationView : MKAnnotationView

@property (nonatomic,strong)YWStormAnnotationModel * model;
@property (nonatomic,strong)UIImageView * showImageView;


@end

//
//  YWStormPinAnnotationView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/26.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStormPinAnnotationView.h"

@implementation YWStormPinAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        self.showImageView.image = [UIImage imageNamed:@"YW_Map_Annotation"];
        [self addSubview:self.showImageView];
    }
    return self;
}

- (void)setModel:(YWStormAnnotationModel *)model{
    if (!model)return;
    _model = model;
    self.size = CGSizeMake(30.f, 30.f);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end

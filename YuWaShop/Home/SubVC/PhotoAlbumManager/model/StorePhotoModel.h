//
//  StorePhotoModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/3.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//'id':123,
//'title':'图片标题',
//'url':'http://xxx.com/xxx.jpg',

@interface StorePhotoModel : NSObject
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*url;

@end

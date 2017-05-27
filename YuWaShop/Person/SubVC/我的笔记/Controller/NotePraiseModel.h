//
//  NotePraiseModel.h
//  YuWa
//
//  Created by double on 17/4/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotePraiseModel : NSObject
@property (nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * info;
@property (nonatomic,strong)NSString * content;//内容
@property (nonatomic,strong)NSString * note_id;
@property (nonatomic,strong)NSString * like_nums;//被赞数量
@property (nonatomic,strong)NSString * img;
@property (nonatomic,strong)NSString * collect_nums;//被收藏数
@end

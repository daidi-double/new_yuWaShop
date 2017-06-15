//
//  ChildModel.h
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildModel : NSObject

@property (nonatomic,copy)NSString * company_name;//店铺名称
@property (nonatomic,copy)NSString * username;//账号
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,strong)NSArray * route;//权限
@end

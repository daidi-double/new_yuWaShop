//
//  MainAccountListModel.h
//  雨掌柜
//
//  Created by double on 17/6/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainAccountListModel : NSObject
@property (nonatomic,copy)NSString * username;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * company_name;
@property (nonatomic,copy)NSString * is_current;//当前账号，0不是，1是
@property (nonatomic,copy)NSString * isChild;//是否为子账号 0 不是，1是

@end

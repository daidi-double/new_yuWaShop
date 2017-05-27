//
//  BusinessMumberHeaderView.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessMumberHeaderView : UIView
@property (nonatomic,strong)NSMutableArray * BGImgArr;
@property (weak, nonatomic) IBOutlet UIImageView *boliangImageView;
@property(nonatomic,strong)void(^TotailBlock)();
@property(nonatomic,strong)void(^waitBlock)();

@end

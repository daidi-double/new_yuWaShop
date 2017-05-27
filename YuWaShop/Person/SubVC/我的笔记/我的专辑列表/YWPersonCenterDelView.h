//
//  YWPersonCenterDelView.h
//  YuWa
//
//  Created by Tian Wei You on 16/11/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPersonCenterDelView : UIView
@property (nonatomic,copy)void (^delNodeClock)();
@property (nonatomic,copy)void (^delAldumClock)();

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

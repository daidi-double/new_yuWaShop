//
//  MDHotelRightBtn.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDHotelChooseTypeTableVC.h"
@interface MDHotelRightBtn : UIView
@property (nonatomic,assign)BOOL isOn;

@property (nonatomic,copy)void(^chooseTypeBlock)(NSString *);
@property (nonatomic,strong)MDHotelChooseTypeTableVC * typeTableV;
@property (nonatomic,strong)UIView * typeView;
@property (nonatomic,assign)NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

- (void)tapAction;

@end

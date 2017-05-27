//
//  YWPCCutPickerView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPCCutPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,copy)void (^saveBlock)(NSString *,NSInteger,NSString *);

@property (nonatomic,strong)UIPickerView * picker;
@property (nonatomic,copy)NSString * cut;
@property (nonatomic,assign)NSInteger cutInter;
@property (nonatomic,strong)NSArray * cutArr;

- (void)makePickerView;
- (void)saveAvtion;

@end

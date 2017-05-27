//
//  JWImgPickerAlbumChooseView.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWImgPickerAlbumChooseTableView.h"

@interface JWImgPickerAlbumChooseView : UIView

@property (nonatomic,assign)BOOL isOn;

@property (nonatomic,copy)void(^chooseTypeBlock)(NSString *);
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,strong)JWImgPickerAlbumChooseTableView * typeTableV;
@property (nonatomic,strong)UIView * typeView;
@property (nonatomic,assign)NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;

- (void)tapAction;

@end

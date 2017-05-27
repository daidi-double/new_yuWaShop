//
//  JWImgPickerAlbumChooseTableView.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWImgPickerAlbumChooseTableView : UITableView

@property (nonatomic,copy)void(^choosedTypeBlock)(NSString *,NSString *);

@property (nonatomic,strong)NSArray * dataArr;

@end

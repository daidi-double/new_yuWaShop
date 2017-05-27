//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZAlbumModel;
@interface TZPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, strong) TZAlbumModel *model;

@property (nonatomic,strong)NSMutableArray * albumArr;//所有照片数组

@property (nonatomic,strong)NSMutableArray * imageChangeSaveArr;//小红书编辑照片后数据
@property (nonatomic,strong)NSMutableArray * photoSaveArr;//小红书存储对照数据

@property (nonatomic, copy) void (^backButtonClickHandle)(TZAlbumModel *model);

@end

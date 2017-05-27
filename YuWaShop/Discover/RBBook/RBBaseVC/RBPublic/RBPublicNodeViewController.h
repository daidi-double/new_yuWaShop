//
//  RBPublicNodeViewController.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBBasicViewController.h"
#import "RBPublicEditorViewController.h"

@interface RBPublicNodeViewController : RBBasicViewController

@property (nonatomic,strong)NSArray * photos;

@property (nonatomic,strong)NSMutableArray * imageChangeSaveArr;//小红书编辑照片后数据
@property (nonatomic,assign)NSInteger imagePage;

- (void)reSetData;

@end

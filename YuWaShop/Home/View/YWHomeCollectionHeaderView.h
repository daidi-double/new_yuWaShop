//
//  YWHomeCollectionHeaderView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWHomeCollectionHeaderView : UICollectionReusableView
@property (nonatomic,copy)void (^payBlock)();
@property (nonatomic,copy)void (^recordBlock)();

@property (nonatomic,strong)NSMutableArray * BGImgArr;
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;



@end

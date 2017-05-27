//
//  PCBottomTableViewCell.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,showViewCategory){
    showViewCategoryNotes=0,
    showViewCategoryAlbum=1,
   
    
    
    
};

@protocol PCBottomTableViewCellDelegate <NSObject>

-(void)DelegateForNote:(NSInteger)number;    //-1 为发布

-(void)DelegateForAlbum:(NSInteger)number andMax:(NSInteger)maxNumber;  //专辑



@end

@interface PCBottomTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDatas:(NSMutableArray*)allDatas andWhichCategory:(showViewCategory)number;


@property(nonatomic,assign)id<PCBottomTableViewCellDelegate>delegate;
@end

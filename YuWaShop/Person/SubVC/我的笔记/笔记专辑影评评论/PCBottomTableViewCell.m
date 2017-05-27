//
//  PCBottomTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCBottomTableViewCell.h"
#import "PCNoteView.h"
#import "AlbumView.h"


@interface PCBottomTableViewCell()

@end


@implementation PCBottomTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDatas:(NSMutableArray*)allDatas andWhichCategory:(showViewCategory)number{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        switch (number) {
            case showViewCategoryNotes:{
               
                PCNoteView*view=[[PCNoteView alloc]initWithFrame:self.frame andArray:allDatas];
                [self addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self);
                    
                    
                }];
                
                //代理回控制器 来控制跳转
                view.touchCellBlock=^(NSInteger number){
                    if ([self.delegate respondsToSelector:@selector(DelegateForNote:)]) {
                        [self.delegate DelegateForNote:number];
                    }
            
                };
                
                break;}
            case showViewCategoryAlbum:{
            
                AlbumView*view=[[AlbumView alloc]initWithFrame:self.frame andArray:allDatas];
                [self addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self);
                }];
                view.touchCellBlock=^(NSInteger number,NSInteger maxNumber){
                    if ([self.delegate respondsToSelector:@selector(DelegateForAlbum:andMax:)]) {
                        [self.delegate DelegateForAlbum:number andMax:maxNumber];
                    }
                    
                    
                };
                
                
                break;}
           
            default:
                break;
        }
        
        
        
        
    }
    
    return self;
    
}



@end

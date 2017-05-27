//
//  PCNoteView.h
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCNoteView : UIView

@property (nonatomic,assign)BOOL isOther;

//-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas withIsOther:(BOOL)isOther;

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas;

@property(nonatomic,strong)void(^touchCellBlock)(NSInteger number);
@end

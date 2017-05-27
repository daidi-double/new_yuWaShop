//
//  JWTagScrollView.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWTagScrollView.h"
#import "JWTools.h"

@interface JWTagScrollView()
@property (nonatomic,assign)NSInteger chooseTagIdx;

@end

@implementation JWTagScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setTagArr:(NSArray *)tagArr{
    if (!tagArr)return;
    _tagArr = tagArr;
    [self makeTagBtn];
}

- (void)makeTagBtn{
//    CGFloat btnHeight = 36.f;
//    for (int i = 0; i<self.tagArr.count; i++) {
//        CGFloat btnWidth = [JWTools sizeForText:self.tagArr[i] withFont:[UIFont systemFontOfSize:15.f] withSize:CGSizeMake(MAXFLOAT, 21.f)].width;
//        
//    }
    
}

- (void)tagBtnAction:(UIButton *)sender{
    self.chooseTagIdx = sender.tag;
    self.chooseTagBlock(sender.titleLabel.text);
}

@end

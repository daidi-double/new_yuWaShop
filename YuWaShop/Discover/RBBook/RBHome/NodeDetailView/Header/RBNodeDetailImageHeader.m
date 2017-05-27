//
//  RBNodeDetailImageHeader.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailImageHeader.h"
#import "XHTagView.h"

@implementation RBNodeDetailImageHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollImageView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, frame.size.height)];
        self.scrollImageView.backgroundColor = [UIColor whiteColor];
        self.scrollImageView.contentSize = CGSizeMake(kScreen_Width, 0.f);
        self.scrollImageView.tag = 10086;
        self.scrollImageView.showsVerticalScrollIndicator = NO;
        self.scrollImageView.showsHorizontalScrollIndicator = NO;
        self.scrollImageView.bounces = NO;
        self.scrollImageView.pagingEnabled = YES;
        [self addSubview:self.scrollImageView];
        [self clearTmpPics];//清除缓存,否则直接加载
    }
    return self;
}


- (void)setImageList:(NSArray *)imageList{
    if (!imageList)return;
    _imageList = imageList;
    [self dataSet];
}

- (void)dataSet{
    RBHomeListImagesModel * imageModel;
    if (self.imageList.count == 0) {
        imageModel = [[RBHomeListImagesModel alloc]init];
        imageModel.original = @"";
        imageModel.url = imageModel.original;
        imageModel.height = @"0";
        imageModel.width = @"0";
    }else{
        imageModel = self.imageList[0];
    }
    self.scrollImageView.frame = CGRectMake(0.f, 0.f, kScreen_Width, kScreen_Width * ([imageModel.height floatValue]>0?[imageModel.height floatValue]:320.f) / ([imageModel.width floatValue]>0?[imageModel.width floatValue]:320.f));
    self.height = self.scrollImageView.height;
    self.scrollImageView.contentSize = CGSizeMake(kScreen_Width * self.imageList.count, 0.f);
    WEAKSELF;
    [self.imageList enumerateObjectsUsingBlock:^(RBHomeListImagesModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(idx * kScreen_Width, 0.f, kScreen_Width, kScreen_Width * ([imageModel.height floatValue]>0?[imageModel.height floatValue]:320.f) / ([imageModel.width floatValue]>0?[imageModel.width floatValue]:320.f))];
        __weak typeof(imageView) weakImageView = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (idx == 0) {
                imageView.frame = CGRectMake(0.f, 0.f, 0.f, 0.f);
                [UIView animateWithDuration:0.4 animations:^{
                    weakImageView.frame = CGRectMake(0.f, 0.f, kScreen_Width, kScreen_Width * ([imageModel.height floatValue]>0?[imageModel.height floatValue]:320.f) / ([imageModel.width floatValue]>0?[imageModel.width floatValue]:320.f));
                } completion:^(BOOL finished) {
                    weakSelf.backgroundColor = [UIColor clearColor];
                    weakSelf.alpha = 1.f;
                }];
            }
        }];
        imageView.tag = idx + 1;
        [self.scrollImageView addSubview:imageView];
    }];
    
}

- (void)refreshWithHeight:(CGFloat)height{//滑动刷新
    if (self.height == height)return;
    self.height = height;
    self.scrollImageView.height = height;
    self.scrollImageView.contentSize = CGSizeMake(self.scrollImageView.contentSize.width, height);
    for (int i = 1; i<=self.imageList.count; i++) {
        UIImageView * imageView = [self viewWithTag:i];
        imageView.frame = CGRectMake(imageView.x, imageView.y, imageView.width, height);
    }
}

- (void)clearTmpPics{//清除缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

- (void)setTagArr:(NSArray *)tagArr{
    if (!tagArr)return;
    NSMutableArray * tagArrTemp = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<tagArr.count; i++) {
        NSArray * arrTemp = tagArr[i];
        NSMutableArray * tagTemp = [NSMutableArray arrayWithCapacity:0];
        if (arrTemp.count>0) {
            for (int j = 0; j<arrTemp.count; j++) {
                [tagTemp addObject:[RBPublicTagSaveModel yy_modelWithJSON:arrTemp[j]]];
            }
        }
        [tagArrTemp addObject:tagTemp];
    }
    BOOL isShowed = _tagArr?NO:YES;
    if (tagArr.count>0) {
        _tagArr = tagArrTemp;
    }else{
        _tagArr = tagArr;
    }
    if (isShowed) [self showTag];
}

- (void)showTag{
    for (int i = 0; i<self.tagArr.count; i++) {
        NSArray * dataArr = self.tagArr[i];
        if (dataArr.count>0) {
            for (RBPublicTagSaveModel * model in dataArr) {
                [self tagViewmakeWithTextArr:model.tagTextArr withPoint:CGPointMake(model.x, model.y) withStyle:model.tagAnimationStyle withView:[self.scrollImageView viewWithTag:i+1]];
            }
        }
    }
}

- (void)tagViewmakeWithTextArr:(NSArray *)textArr withPoint:(CGPoint)point withStyle:(XHTagAnimationStyle)animationStyle withView:(UIView *)showView{
    XHTagView * tagView = [[XHTagView alloc]init];
    tagView.branchTexts = [NSMutableArray arrayWithArray:textArr];
    tagView.centerLocationPoint = point;
    tagView.tagAnimationStyle = animationStyle;
    [showView addSubview:tagView];
    [tagView showInPoint:point];
}



@end

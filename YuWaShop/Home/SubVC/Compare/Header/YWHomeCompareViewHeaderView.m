//
//  YWHomeCompareViewHeaderView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCompareViewHeaderView.h"
#import "NSDictionary+Attributes.h"

@implementation YWHomeCompareViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    self.typeSegmentedControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 58.f) titleDataSource:@[[UserSession instance].shopType?[UserSession instance].shopType:@"美食",[UserSession instance].shopSubTypeArr.count>0?[UserSession instance].shopSubTypeArr[0]:@"火锅"] backgroundColor:[UIColor clearColor] titleColor:CNaviColor titleFont:[UIFont boldSystemFontOfSize:15.f] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    self.typeSegmentedControl.isCancelSame = YES;
    [self addSubview:self.typeSegmentedControl];
    
    UISegmentedControl * segmentControl= [[UISegmentedControl alloc]initWithItems:@[@"店铺浏览",@"消费人数",@"消费金额",@"平均评分"]];
    segmentControl.frame = CGRectMake(20.f, CGRectGetMaxY(self.typeSegmentedControl.frame) + 17.f, self.frame.size.width - 40.f, 30.f);
    segmentControl.selectedSegmentIndex = 0;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor colorWithHexString:@"#25C0E9"]] forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    segmentControl.tintColor = CNaviColor;
    segmentControl.layer.borderColor = CNaviColor.CGColor;
    [segmentControl setDividerImage:[UIImage imageNamed:@"segmentLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    segmentControl.layer.borderWidth = 2.f;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    [segmentControl addTarget:self action:@selector(compareTypeSegmentControlAcyion:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segmentControl];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height - 1.f, self.frame.size.width, 1.f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
    [self addSubview:lineView];
}

- (void)compareTypeSegmentControlAcyion:(UISegmentedControl *)sender{
    self.compareTypeBlock(sender.selectedSegmentIndex);
}

#pragma mark - YJSegmentedControlDelegate
-(void)segumentSelectionChange:(NSInteger)selection{
    if (selection == self.showTypeSelection && selection == 1) {
        self.changeSubTypeBlock();
    }else if(selection != self.showTypeSelection){
        self.showTypeBlock(selection == 0);
    }
    self.showTypeSelection = selection;
}

@end

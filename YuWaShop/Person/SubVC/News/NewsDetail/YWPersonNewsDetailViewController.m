//
//  YWPersonNewsDetailViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonNewsDetailViewController.h"
#import "YWPersonNewsDetailModel.h"
#import "YWPNDetailView.h"
#import "YWPNRankView.h"
#import "YWPNPublicPraiseView.h"
#import "YWPNPopularityView.h"

#import "NSString+JWAppendOtherStr.h"

@interface YWPersonNewsDetailViewController ()

@property (nonatomic,strong)YWPersonNewsDetailModel * model;

@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)YWPNDetailView * detailView;
@property (nonatomic,strong)YWPNRankView * rankView;
@property (nonatomic,strong)YWPNPublicPraiseView * publicPraiseView;
@property (nonatomic,strong)YWPNPopularityView * popularityView;

@end

@implementation YWPersonNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店日报";
    [self makeUI];
    [self requestData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.publicPraiseView.height<300.f) {
        self.publicPraiseView.frame = CGRectMake(0.f, 165.f, kScreen_Width, 292.f);
        self.rankView.frame = CGRectMake(0.f, 457.f, kScreen_Width, 320.f);
        self.popularityView.frame = CGRectMake(0.f, 777.f, kScreen_Width, 285.f);
    }
}

- (void)makeUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, kScreen_Height)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    self.detailView = [[[NSBundle mainBundle]loadNibNamed:@"YWPNDetailView" owner:nil options:nil]firstObject];
    self.detailView.frame = CGRectMake(0.f, 0.f, kScreen_Width, 165.f);
    [self.detailView setNeedsLayout];
    [self.scrollView addSubview:self.detailView];
    
    self.publicPraiseView = [[[NSBundle mainBundle]loadNibNamed:@"YWPNPublicPraiseView" owner:nil options:nil]firstObject];
    self.publicPraiseView.frame = CGRectMake(0.f, 165.f, kScreen_Width, 292.f);
    [self.publicPraiseView setNeedsDisplay];
    [self.scrollView addSubview:self.publicPraiseView];
    
    self.rankView = [[[NSBundle mainBundle]loadNibNamed:@"YWPNRankView" owner:nil options:nil]firstObject];
    self.rankView.frame = CGRectMake(0.f, 457.f, kScreen_Width, 320.f);
    [self.rankView setNeedsLayout];
    [self.scrollView addSubview:self.rankView];
    
    self.popularityView = [[[NSBundle mainBundle]loadNibNamed:@"YWPNPopularityView" owner:nil options:nil]firstObject];
    self.popularityView.frame = CGRectMake(0.f, 777.f, kScreen_Width, 285.f);
    [self.popularityView setNeedsLayout];
    [self.scrollView addSubview:self.popularityView];
    
    self.scrollView.contentSize = CGSizeMake(kScreen_Width, 1062.f);
}

- (void)UIDataRefresh{
    self.detailView.nameLabel.text = [UserSession instance].nickName;
    self.detailView.timeLabel.text = self.newsTime;
    self.detailView.conLabel.text = [NSString stringWithFormat:@"您的门店经营状况平稳,超过同城%@的同业商家",self.model.my_star_buzz];
    self.detailView.compareLabel.text = @"数据为昨日单日数据,增长下降趋势为上周同日";
    
    self.publicPraiseView.commentCountLabel.text = [NSString stringWithFormat:@"评论数·%zi",self.model.all_comment_nums];
    self.publicPraiseView.goodCommentCountLabel.text = [NSString stringWithFormat:@"好评数·%zi",self.model.good_comment_nums];
    self.publicPraiseView.badCommentCountLabel.text = [NSString stringWithFormat:@"差评数·%zi",self.model.bad_comment_nums];
    
    self.rankView.rankLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%zi",self.model.my_star] withFont:[UIFont boldSystemFontOfSize:32.f] withColor:CNaviColor withSecondtStr:@"名" withFont:[UIFont systemFontOfSize:24.f] withColor:CNaviColor];
    self.rankView.rankCompareLabel.attributedText = [NSString stringWithFirstStr:([self.model.ranking_change integerValue]>=0?@"⬆︎":@"⬇︎") withFont:[UIFont systemFontOfSize:17.f] withColor:CNaviColor withSecondtStr:[NSString stringWithFormat:@"%zi名",([self.model.buzz integerValue]>=0?[self.model.ranking_change integerValue]:(-[self.model.ranking_change integerValue]))] withFont:[UIFont systemFontOfSize:24.f] withColor:CNaviColor];
    self.rankView.rankDetailLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"您在同城同行%@家商户中排行 ",self.model.shop_nums] withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor colorWithHexString:@"#343434"] withSecondtStr:[NSString stringWithFormat:@"%zi",self.model.my_star] withFont:[UIFont systemFontOfSize:22.f] withColor:[UIColor colorWithHexString:@"#343434"]];
    
    NSMutableAttributedString * rankCheerStr =[NSString stringWithFirstStr:@"领先" withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor colorWithHexString:@"#343434"] withSecondtStr:[NSString stringWithFormat:@"%@",self.model.my_star_buzz] withFont:[UIFont systemFontOfSize:22.f] withColor:[UIColor colorWithHexString:@"#343434"]];
    [rankCheerStr appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"的同行,请再接再厉" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#343434"],NSFontAttributeName:[UIFont systemFontOfSize:15.f]}]];
    self.rankView.rankCheerLabel.attributedText = rankCheerStr;
    
    self.popularityView.compareLabel.attributedText = [NSString stringWithFirstStr:([self.model.buzz integerValue]>0?@"⬆︎":@"⬇︎") withFont:[UIFont systemFontOfSize:17.f] withColor:CNaviColor withSecondtStr:[NSString stringWithFormat:@"%zi%%",([self.model.buzz integerValue]>0?[self.model.buzz integerValue]:(-[self.model.buzz integerValue]))] withFont:[UIFont systemFontOfSize:28.f] withColor:CNaviColor];
    self.popularityView.pageViewCountLabel.attributedText = [NSString stringWithFirstStr:@"门店浏览人数  " withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor colorWithHexString:@"#343434"] withSecondtStr:[NSString stringWithFormat:@"%@",self.model.today_log] withFont:[UIFont systemFontOfSize:26.f] withColor:[UIColor blackColor]];
    NSMutableAttributedString * pageViewCompareStr =[NSString stringWithFirstStr:@"店铺浏览量相比昨天  " withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor colorWithHexString:@"#343434"] withSecondtStr:[NSString stringWithFormat:@"%@",([self.model.buzz integerValue]>0?@"⬆︎":@"⬇︎")] withFont:[UIFont systemFontOfSize:17.f] withColor:[UIColor colorWithHexString:@"#4ed761"]];
    [pageViewCompareStr appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zi%%",([self.model.buzz integerValue]>0?[self.model.buzz integerValue]:(-[self.model.buzz integerValue]))] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4ed761"],NSFontAttributeName:[UIFont systemFontOfSize:28.f]}]];
    self.popularityView.pageViewCompareLabel.attributedText = pageViewCompareStr;
}

#pragma mark - Http
- (void)requestData{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"date":self.newsTime};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_DailyOperation withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.model = [YWPersonNewsDetailModel yy_modelWithDictionary:responsObj[@"data"]];
        [self UIDataRefresh];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }]; //h3333333333333
}

@end

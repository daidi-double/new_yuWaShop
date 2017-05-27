//
//  YWFansViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWFansViewController.h"
#import "YWFansTableViewCell.h"
#import "JWTools.h"
#import "AbountAndFansModel.h"
#import "NotePraiseModel.h"
//#import "YWOtherSeePersonCenterViewController.h"
#import "RBNodeShowViewController.h"

#define  CELL0  @"YWFansTableViewCell"

@interface YWFansViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*maMallDatas;
@end

@implementation YWFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=_titleStr;
    self.automaticallyAdjustsScrollViewInsets=YES;
    switch (self.whichFriend) {
        case TheFirendsAbount:
            self.title=@"我的关注";
            break;
        case TheFirendsFans:
            self.title=@"我的粉丝";
            break;
        case TheFirendsTaAbount:
            self.title=@"Ta的关注";
            break;
        case TheFirendsTaFans:
            self.title=@"Ta的粉丝";
            break;
        case TheFriendsBePraise:
            self.title=@"被赞";
            break;
        case TheFriendsBeCollected:
            self.title=@"被收藏";
            break;
        default:
            break;
    }

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpMJRefresh];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
    
}

#pragma mark  --UI
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    WEAKSELF;
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        weakSelf.pages=0;
        weakSelf.maMallDatas=[NSMutableArray array];
        [weakSelf getDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        weakSelf.pages++;
        [weakSelf getDatas];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maMallDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whichFriend != TheFriendsBePraise && self.whichFriend != TheFriendsBeCollected) {
        
        YWFansTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        cell.praiseLabel.hidden = YES;
        AbountAndFansModel*model=self.maMallDatas[indexPath.row];
        
        //图片
        UIImageView*imageView=[cell viewWithTag:1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.header_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        //名字
        UILabel*nameLabel=[cell viewWithTag:2];
        nameLabel.text=model.nickname;
        if ([JWTools isNumberWithStr:model.nickname]) {
            NSString * name = [model.nickname substringToIndex:7];
            nameLabel.text = [NSString stringWithFormat:@"%@****",name];
        }
        //info
        UILabel*infoLabel=[cell viewWithTag:3];
        infoLabel.text=[NSString stringWithFormat:@"%@条笔记，%@个粉丝",model.note_num,model.fans];
        
        //button
        if ([UserSession instance].uid == [model.uid integerValue]) {
            cell.touchButton.hidden = YES;
        }else{
            if (model.is_attention) {
                //已经关注了  那么取消关注
                [cell.touchButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                cell.touchButton.layer.borderColor=CpriceColor.CGColor;
                [cell.touchButton setTitleColor:CpriceColor forState:UIControlStateNormal];
                [cell.touchButton setTitle:@"取消关注" forState:UIControlStateNormal];
                cell.touchButton.tag=indexPath.row;
                [cell.touchButton addTarget:self action:@selector(ButtonCancelAbount:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                //没关注  那么
                [cell.touchButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                cell.touchButton.layer.borderColor=CNaviColor.CGColor;
                [cell.touchButton setTitleColor:CNaviColor forState:UIControlStateNormal];
                cell.touchButton.tag=indexPath.row;
                [cell.touchButton setTitle:@"+关注" forState:UIControlStateNormal];
                [cell.touchButton addTarget:self action:@selector(ButtonAddAbount:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return cell;
        
    }else{
        YWFansTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.selectionStyle=NO;
        
        NotePraiseModel*model=self.maMallDatas[indexPath.row];
        //图片
        UIImageView*imageView=[cell viewWithTag:1];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        //名字
        UILabel*nameLabel=[cell viewWithTag:2];
        nameLabel.text=model.title;
        
        //info
        UILabel*infoLabel=[cell viewWithTag:3];
        infoLabel.width = cell.width *0.5;
        infoLabel.text= [model.info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //button
        cell.praiseLabel.hidden = NO;
        cell.praiseLabel.text = [NSString stringWithFormat:@"被赞%@次",model.like_nums];
        if (self.whichFriend == TheFriendsBeCollected) {
          cell.praiseLabel.text = [NSString stringWithFormat:@"被收藏%@次",model.collect_nums];
        }
        cell.touchButton.hidden = YES;
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.whichFriend !=TheFriendsBeCollected && self.whichFriend != TheFriendsBePraise) {
        NSInteger number=indexPath.row;
        AbountAndFansModel*model=self.maMallDatas[number];
        if ([UserSession instance].uid == [model.uid integerValue]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
//            YWOtherSeePersonCenterViewController*vc=[[YWOtherSeePersonCenterViewController alloc]init];
//            
//            vc.uid=model.uid;
//            vc.nickName = model.nickname;
//            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        NotePraiseModel * model = self.maMallDatas[indexPath.row];
        RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
        vc.isUser = YES;
        vc.note_id = model.note_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

#pragma mark  -- jiekou 

-(void)getDatas{
    switch (self.whichFriend) {
        case TheFirendsAbount:
          
            [self getDatasMyAbount];
            break;
        case TheFirendsFans:
           
             [self getDatasMyFans];
            break;
        case TheFirendsTaAbount:
            
            [self getDatasTaAbount];
          
            break;
        case TheFirendsTaFans:
            
            [self getDatasTaFans];
            break;
        case TheFriendsBePraise:
            [self getDatasBePraise];
            break;
        case TheFriendsBeCollected:
            [self getDatasBeCollect];
            break;
   
        default:
            break;
    }

    
}


-(void)getDatasMyAbount{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYABOUNT];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            for (NSDictionary*dict in data[@"data"]) {
                AbountAndFansModel*model=[AbountAndFansModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}


-(void)getDatasMyFans{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYFANS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
         MyLog(@"data fans = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                AbountAndFansModel*model=[AbountAndFansModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }

            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
    
}


-(void)getDatasTaAbount{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_TAABOUNT];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_uid":@(self.other_uid),@"pagen":pagen,@"pages":pages,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"他的关注%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                AbountAndFansModel*model=[AbountAndFansModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }

            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
    
}


-(void)getDatasTaFans{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_TAFANS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_uid":@(self.other_uid),@"pagen":pagen,@"pages":pages,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"他的粉丝%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                AbountAndFansModel*model=[AbountAndFansModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }

            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
}
//被赞
-(void)getDatasBePraise{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYNOTEBEPRAISE];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data被赞 = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {

            for (NSDictionary*dict in data[@"data"]) {
                NotePraiseModel*model=[NotePraiseModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];

        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}
//被收藏
-(void)getDatasBeCollect{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MYNOTEBECOLLECT];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data被收藏 = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            for (NSDictionary*dict in data[@"data"]) {
                NotePraiseModel*model=[NotePraiseModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

#pragma mark  -- 加关注和  取消关注
-(void)ButtonCancelAbount:(UIButton*)sender{
    AbountAndFansModel*model=self.maMallDatas[sender.tag];
    //变成取消关注
    model.is_attention=NO;
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_DELABOUT];

    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":model.uid,@"user_type":@(2),@"auser_type":model.user_type};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [UserSession instance].attentionCount = [NSString stringWithFormat:@"%zi",[[UserSession instance].attentionCount integerValue]-1];
            
           
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
             [self.tableView.mj_header beginRefreshing];
        }
        
        
    }];

    
    
    
}


-(void)ButtonAddAbount:(UIButton*)sender{
    AbountAndFansModel*model=self.maMallDatas[sender.tag];
    //变成加为关注
    model.is_attention=YES;
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ADDABOUT];
    
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"attention_id":model.uid,@"user_type":@(2),@"auser_type":model.user_type};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [UserSession instance].attentionCount = [NSString stringWithFormat:@"%zi",[[UserSession instance].attentionCount integerValue]+1];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            [self.tableView.mj_header beginRefreshing];
        }
        
        
    }];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark  --tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end

//
//  YWAddressSortTableView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWAddressSortTableView.h"
#import "HttpObject.h"
#import "YWAddressBaseComfiredTypeModel.h"
#import "JWTools.h"

@implementation YWAddressSortTableView
- (instancetype)initAddressWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        self.dataStateArr = [NSMutableArray arrayWithCapacity:0];
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
        self.dataSource = self;
        self.delegate = self;
        [self requestSubTypeWithIdx:0];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == indexPath.row)return;
    self.selectIndex = indexPath.row;
    [self reloadData];
    [self requestSubTypeWithIdx:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * typeStormCell = [tableView dequeueReusableCellWithIdentifier:@"typeStormCell"];
    if (!typeStormCell) {
        typeStormCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeStormCell"];
    }
    typeStormCell.selectionStyle = UITableViewCellSelectionStyleNone;
    YWAddressBaseComfiredTypeModel * model = self.dataArr[indexPath.row];
    if (indexPath.row == self.selectIndex) {
        typeStormCell.tintColor = CNaviColor;
        typeStormCell.textLabel.textColor = CNaviColor;
        typeStormCell.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
    }else{
        typeStormCell.textLabel.textColor = CsubtitleColor;
        typeStormCell.backgroundColor = [UIColor whiteColor];
    }
    typeStormCell.textLabel.text = model.class_name;
    typeStormCell.textLabel.font = [UIFont systemFontOfSize:15.f];
    
    if (![typeStormCell viewWithTag:10086]) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 43.f, kScreen_Width, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        lineView.tag = 10086;
        [typeStormCell addSubview:lineView];
    }
    typeStormCell.alpha = 1.f;
    return typeStormCell;
}

#pragma mark - Http
- (void)requestSubTypeWithIdx:(NSInteger)index{
    if (self.dataArr.count<=0) {
        NSDictionary * pragram = @{@"device_id":[JWTools getUUID]};
        
        [[HttpObject manager]postNoHudWithType:YuWaType_SHOP_GETCATEGORY withPragram:pragram success:^(id responsObj) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code is %@",responsObj);
            NSArray * dataArr = responsObj[@"data"][@"allBusiness"];
            for (int i = 1; i<dataArr.count; i++) {
                [self.dataArr addObject:[YWAddressBaseComfiredTypeModel yy_modelWithDictionary:dataArr[i]]];
            }
            [self reloadData];
            if (self.dataArr.count>0) {
                YWAddressBaseComfiredTypeModel * model = self.dataArr[0];
                self.choosedTypeBlock([model.typeID integerValue],model.class_name,model.business);
            }
        } failur:^(id responsObj, NSError *error) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code error is %@",responsObj);
        }];
    }else{
        YWAddressBaseComfiredTypeModel * model = self.dataArr[index];
        self.choosedTypeBlock([model.typeID integerValue],model.class_name,model.business);
    }
}

@end

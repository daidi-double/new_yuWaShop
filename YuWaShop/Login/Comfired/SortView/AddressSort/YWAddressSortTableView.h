//
//  YWAddressSortTableView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWAddressSortTableView: UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger selectIndex;

@property (nonatomic,copy)void(^choosedTypeBlock)(NSInteger,NSString *,NSArray *);

@property (nonatomic,strong)NSMutableArray * dataStateArr;

- (void)requestSubTypeWithIdx:(NSInteger)index;

@property (nonatomic,strong)NSMutableArray * subDataArr;

- (instancetype)initAddressWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end

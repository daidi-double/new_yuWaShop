//
//  YWHomeCompareSortTableView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWHomeCompareSortTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger selectIndex;

@property (nonatomic,copy)void(^choosedTypeBlock)(NSInteger);

@end

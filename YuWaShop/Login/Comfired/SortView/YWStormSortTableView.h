//
//  YWStormSortTableView.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWStormSortTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger selectIndex;

@property (nonatomic,copy)void(^choosedTypeBlock)(NSInteger,NSInteger,NSArray *,NSString *);

@property (nonatomic,strong)NSMutableArray * dataStateArr;

- (void)requestSubTypeWithIdx:(NSInteger)index;

@end

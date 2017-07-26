//
//  VideoViewController.h
//  雨掌柜
//
//  Created by double on 17/7/10.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoViewController : UIViewController
@property (nonatomic,assign)NSInteger status;//0主动发起方，1接收方
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic,strong)EMCallSession * callSession;
@property (nonatomic,assign)BOOL isHidden;
@property (nonatomic,strong)NSString * friendsHXID;
@property (nonatomic,strong)NSString * friendsName;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)NSString * remoteUsername;
@property (nonatomic,strong)NSString * friendsIcon;
@property (nonatomic,strong)EMConversation * conversation;
@property (nonatomic,copy) void (^addBlock)(EMMessage*);
- (void)clearData;
@end

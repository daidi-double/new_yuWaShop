//
//  VoiceChatViewController.h
//  雨掌柜
//
//  Created by double on 17/7/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface VoiceChatViewController : UIViewController
@property (nonatomic,strong)NSString * friendsName;
@property (nonatomic,strong)NSString * friendsnikeName;
@property (nonatomic,strong)EMCallSession * callSession;
@property (nonatomic,assign)BOOL isHidden;
@property (nonatomic,strong)NSString * friendsHXID;
@property (nonatomic,strong)NSString * friendsIcon;
@property (nonatomic,strong)NSString * remoteUsername;
@property (nonatomic,assign)NSInteger status;//0主动发起方，1接收方
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (void)clearData;
@end

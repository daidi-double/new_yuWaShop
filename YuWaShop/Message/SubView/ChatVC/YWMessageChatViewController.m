//
//  YWMessageChatViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageChatViewController.h"

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "NSDate+Category.h"
#import "EaseUsersListViewController.h"
#import "EaseMessageReadManager.h"
#import "EaseEmotionManager.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseCustomMessageCell.h"
#import "UIImage+EMGIF.h"
#import "EaseLocalDefine.h"
#import "EaseSDKHelper.h"


#import "VoiceChatViewController.h"

#define KHintAdjustY    50

#define IOS_VERSION [[UIDevice currentDevice] systemVersion]>=9.0

@interface YWMessageChatViewController ()<EMCallManagerDelegate>
@property (nonatomic,strong)VoiceChatViewController * voiceController;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)NSString * currentFriendsName;
@property (nonatomic,strong)EMCallSession * currentSession;

@end

@implementation YWMessageChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.friendNikeName?self.friendNikeName:@"聊天";
    //移除实时通话回调
    [[EMClient sharedClient].callManager removeDelegate:self];
    //注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
}

- (void)makeCall:(NSNotification*)notifi{
    
    NSInteger type = [[notifi object][@"type"] integerValue];
    _currentFriendsName = [notifi object][@"chatter"];
    _voiceController = [[VoiceChatViewController alloc]init];

    if (type == 0) {
        self.voiceController.friendsName = self.friendNikeName;
        self.voiceController.isHidden = YES;
        self.voiceController.friendsHXID = [notifi object][@"chatter"];
        self.voiceController.friendsIcon = self.friendIcon;
        [self _startCallTimer];//开始计时
        [self presentViewController:self.voiceController animated:YES completion:nil];
    }else{
        
    }
    
}
/*!
 *  \~chinese
 *  用户A拨打用户B，用户B会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidReceive:(EMCallSession *)aSession{
    _currentSession = aSession;
    MyLog(@"有来电");
    _voiceController = [[VoiceChatViewController alloc]init];

    self.voiceController.callSession = aSession;
//    self.voiceController.statusLabel.hidden = YES;
    if (!aSession.type) {
        self.voiceController.isHidden = NO;
        
        [self presentViewController:self.voiceController animated:YES completion:nil];
        
    }else{//视频
//        self.voiceViewController.type = 1;
//        self.voiceViewController.isSender = NO;
//        [self presentViewController:self.voiceViewController animated:YES completion:nil];
//        
    }
}
- (void)_startCallTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_timeoutBeforeCallAnswered) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}
- (void)_timeoutBeforeCallAnswered
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"对方暂时无法接通", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"好的", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}
/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    [self _stopCallTimer];
    self.voiceController.statusLabel.text = @"正在通话";
}
/*
*  1. 用户A或用户B结束通话后，对方会收到该回调
*  2. 通话出现错误，双方都会收到该回调
*
*  @param aSession  会话实例
*  @param aReason   结束原因
*  @param aError    错误
 */

- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError
{
  
        [self _stopCallTimer];

        if (aReason != EMCallEndReasonHangup) {
            NSString *reasonStr = @"end";
            switch (aReason) {
                case EMCallEndReasonNoResponse:
                {
                    reasonStr = NSLocalizedString(@"对方无人接听", @"NO response");
                }
                    break;
                case EMCallEndReasonDecline:
                {
                    reasonStr = NSLocalizedString(@"对方拒绝了您的通话", @"Reject the call");
                }
                    break;
                case EMCallEndReasonBusy:
                {
                    reasonStr = NSLocalizedString(@"对方正在通话中", @"In the call...");
                }
                    break;
                case EMCallEndReasonFailed:
                {
                    reasonStr = NSLocalizedString(@"连接失败", @"Connect failed");
                }
                    break;
                default:
                    break;
            }
            
            if (aError) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"好的", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"好的", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
            [self.voiceController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    if (_currentSession) {
        
        [[EMClient sharedClient].callManager endCall:_currentSession.sessionId reason:EMCallEndReasonDecline];
        _currentSession = nil;
    }
       [self _clearCurrentCallViewAndData];
    
    

}

- (void)_clearCurrentCallViewAndData
{

        self.currentSession = nil;

        [self.voiceController clearData];

        self.voiceController = nil;
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }else{
        id<IMessageModel> model = object;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
            UITableViewCell *cell = [self.delegate messageViewController:tableView cellForMessageModel:model];
            if (cell) {
                if ([cell isKindOfClass:[EaseMessageCell class]]) {
                    EaseMessageCell *emcell= (EaseMessageCell*)cell;
                    if (emcell.delegate == nil) {
                        emcell.delegate = self;
                    }
                    if ([model.nickname isEqualToString:[NSString stringWithFormat:@"2%@",[UserSession instance].account]]) {
                        emcell.nameLabel.text = [UserSession instance].nickName;
                        [emcell.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                        emcell.hasRead.hidden = YES;
                    }else{
                        emcell.nameLabel.text = self.friendNikeName;
                        [emcell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.friendIcon] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                        emcell.hasRead.hidden = YES;
                    }
                }
                
                return cell;
            }
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
            BOOL flag = [self.dataSource isEmotionMessageFormessageViewController:self messageModel:model];
            if (flag) {
                NSString *CellIdentifier = [EaseCustomMessageCell cellIdentifierWithModel:model];
                //send cell
                EaseCustomMessageCell *sendCell = (EaseCustomMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                // Configure the cell...
                if (sendCell == nil) {
                    sendCell = [[EaseCustomMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
                    sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(emotionURLFormessageViewController:messageModel:)]) {
                    EaseEmotion *emotion = [self.dataSource emotionURLFormessageViewController:self messageModel:model];
                    if (emotion) {
                        model.image = [UIImage sd_animatedGIFNamed:emotion.emotionOriginal];
                        model.fileURLPath = emotion.emotionOriginalURL;
                    }
                }
                sendCell.model = model;
                sendCell.delegate = self;
                if ([model.nickname isEqualToString:[NSString stringWithFormat:@"2%@",[UserSession instance].account]]) {
                    sendCell.nameLabel.text = [UserSession instance].nickName;
                    [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                    sendCell.hasRead.hidden = YES;
                }else{
                    sendCell.nameLabel.text = self.friendNikeName;
                    [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.friendIcon] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
                    sendCell.hasRead.hidden = YES;
                }
                return sendCell;
            }
        }
        
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = model;
        if ([model.nickname isEqualToString:[NSString stringWithFormat:@"2%@",[UserSession instance].account]]) {
            sendCell.nameLabel.text = [UserSession instance].nickName;
            [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
            sendCell.hasRead.hidden = YES;
        }else{
            sendCell.nameLabel.text = self.friendNikeName;
            [sendCell.avatarView sd_setImageWithURL:[NSURL URLWithString:self.friendIcon] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
            sendCell.hasRead.hidden = YES;
        }
        return sendCell;
    }
}

- (void)avatarViewSelcted:(id<IMessageModel>)model{
    if ([model.nickname isEqualToString:[UserSession instance].account])return;
    MyLog(@"用户点击头像");

}

@end

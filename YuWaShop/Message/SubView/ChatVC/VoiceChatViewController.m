//
//  VoiceChatViewController.m
//  雨掌柜
//
//  Created by double on 17/7/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "VoiceChatViewController.h"
#import "HttpObject.h"
#import "VIPTabBarController.h"
#import "YWMessageAddressBookModel.h"
@interface VoiceChatViewController ()<EMCallManagerDelegate,EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (nonatomic,strong)NSString * type;
@property (nonatomic,strong)NSTimer *timeTimer;

@property (strong, nonatomic) AVAudioPlayer *ringPlayer;
@property (nonatomic) int timeLength;
@end

@implementation VoiceChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius= 50;
    _nameLabel.text = _friendsName;
    
    //注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _timeLabel.text = nil;
    if (_status == 0) {
        _rejectBtn.hidden = _isHidden;
        _answerBtn.hidden = _isHidden;
        _hangupBtn.hidden = !_isHidden;
        
    }else{
        [self _beginRing];
        [self getIconAccount:_remoteUsername];
        _rejectBtn.hidden = !_isHidden;
        _answerBtn.hidden = !_isHidden;
        _hangupBtn.hidden = _isHidden;
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_friendsIcon]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (!_callSession) {

        
        [[EMClient sharedClient].callManager startCall:EMCallTypeVoice remoteName:_friendsName ext:nil completion:^(EMCallSession *aCallSession, EMError *aError) {
            

            
            if (!aError) {
                _callSession = aCallSession;
                [self makeUI];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
    }else{
        
        [self makeUI];
    }
}

- (void)makeUI{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//休眠关闭
    _statusLabel.text = @"正在链接";
    _nameLabel.text = _friendsnikeName;

  
    [self.view bringSubviewToFront:_answerBtn];
    [self.view bringSubviewToFront:_hangupBtn];
    [self.view bringSubviewToFront:_rejectBtn];
}

/*!
 *  \~chinese
 *  通话通道建立完成，用户A和用户B都会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidConnect:(EMCallSession *)aSession{
    
    if ([aSession.callId isEqualToString:_callSession.callId]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
}

/*!
 *  \~chinese
 *  用户B同意用户A拨打的通话后，用户A会收到这个回调
 *
 *  @param aSession  会话实例
 */
- (void)callDidAccept:(EMCallSession *)aSession{
    _statusLabel.text = @"正在通话";
    if (_status == 0) {
        
        [self _startTime];
    }
}

/*!
 *  \~chinese
 *  1. 用户A或用户B结束通话后，对方会收到该回调
 *  2. 通话出现错误，双方都会收到该回调
 *
 *  @param aSession  会话实例
 *  @param aReason   结束原因
 *  @param aError    错误
 *
 */
- (void)callDidEnd:(EMCallSession *)aSession reason:(EMCallEndReason)aReason error:(EMError *)aError{

    [[AVAudioSession sharedInstance] setActive:NO error:nil];

    [[EMClient sharedClient].callManager removeDelegate:self];
    
    NSString * text;
    if (aReason == EMCallEndReasonHangup) {
        text = [NSString stringWithFormat:@"通话时长%@",_timeLabel.text];
        
        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"已取消";
            }else{
                text = @"未接听";
            }
        }
    }else if (aReason == EMCallEndReasonDecline){
        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"对方已拒绝";
            }else{
                text = @"已拒绝";
            }
        }
    }else if (aReason == EMCallEndReasonNoResponse){
        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"无人接听";
            }else{
                text = @"有未接电话";
            }
        }
    }else if (aReason == EMCallEndReasonBusy){
        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"对方正在通话中";
            }else{
                text = @"有来电";
            }
        }
    }else if (aReason == EMCallEndReasonFailed){
        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"连接失败";
            }
        }
    }else if (aReason == EMCallEndReasonRemoteOffline){
        if (_timeLabel.text.length == 0) {
            if (_status == 0) {
                
                text = @"对方不在线";
            }
        }
    }
        EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:text];
        EMMessage *textMessage = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:[EMClient sharedClient].currentUsername to:_callSession.callId body:textMessageBody ext:nil];
        textMessage.status = EMMessageStatusSuccessed;
        textMessage.direction = EMMessageDirectionSend;
        textMessage.chatType = (EMChatType)self.conversation.type;
        textMessage.isDeliverAcked = YES;
        /** 刷新当前聊天界面 */
        if (self.addBlock) {
            
            self.addBlock(textMessage);
        }
        
        /** 存入当前会话并存入数据库 */
        
        [self.conversation insertMessage:textMessage error:nil];
        
    
    
    
    _callSession = nil;
    [self _stopRing];
    if (_status == 1) {
        
        [self clearData];
    }
    self.timeLabel.text = nil;
    [self _stopTimeTimer];

    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - private ring

- (void)_beginRing
{
    [self.ringPlayer stop];
    
//    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    SystemSoundID sound = kSystemSoundID_Vibrate;

    NSString *musicPath = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"SIMToolkitGeneralBeep",@"caf"];
    if (musicPath) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:musicPath],&sound);
        if (error != kAudioServicesNoError) {
            sound = 0;
        }
    }
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    self.ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.ringPlayer setVolume:1];
    self.ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([self.ringPlayer prepareToPlay])
    {
        [self.ringPlayer play]; //播放
    }
}
- (void)_stopRing
{
    [self.ringPlayer stop];
}

- (void)_startTime
{
    MyLog(@"开启定时器");
    self.timeLength = 0;
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)_stopTimeTimer
{
    MyLog(@"销毁定时器");
    [self.timeTimer invalidate];
    self.timeTimer = nil;

}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

//拒绝
- (IBAction)rejectAction:(UIButton *)sender {
    [self _stopTimeTimer];
    [self _stopRing];
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonDecline];
        _callSession = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//挂断
- (IBAction)hangupAction:(UIButton *)sender {
    [self _stopTimeTimer];
    [self _stopRing];
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonHangup];
        _callSession = nil;
    }
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//接听
- (IBAction)answerAction:(UIButton *)sender {
    [self _stopRing];
    [self _startTime];
    EMError * error = [[EMClient sharedClient].callManager answerIncomingCall:_callSession.callId];
    
    if (error) {
        
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonFailed];
    }else{
        sender.hidden = YES;
        _rejectBtn.hidden = YES;
        _hangupBtn.hidden = NO;
    }
}
-(void)dealloc{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//休眠关闭
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonHangup];
    }
   
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[EMClient sharedClient].callManager removeDelegate:self];
    _callSession = nil;
    
    
    //    [self stopSystemSound];
    
}
- (void)clearData
{
  [self _stopRing];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];
    if (_callSession) {
        
        [[EMClient sharedClient].callManager endCall:_callSession.callId reason:EMCallEndReasonNoResponse];
        _callSession = nil;
    }
    
    [self _stopTimeTimer];
   
}

- (void)getIconAccount:(NSString *)username{
    
    NSString * account = [username substringFromIndex:1];
    if (username.length == 12) {
        if ([JWTools isPhoneIDWithStr:account]) {
            username = account;
            self.type = @"2";
        }
    }else if ([[username substringToIndex:1] isEqualToString:@"2"]){
        
        if ([JWTools checkIsHaveNumAndLetter:username] == 3) {
            self.type = @"2";
            username = account;
        }else{
            self.type = @"1";
        }
    }else{
        self.type = @"1";
    }
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":username,@"user_type":@(2),@"type":self.type};
    [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
        YWMessageAddressBookModel * modelTemp = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
        NSURL *url = [NSURL URLWithString:modelTemp.header_img]; // 获取的图片地址
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        _iconImageView.image = image;
        if ([modelTemp.friend_remark isEqualToString:@""]) {
            
            self.nameLabel.text = modelTemp.nikeName;
        }else{
            self.nameLabel.text  = modelTemp.friend_remark;
        }
    } failur:^(id errorData, NSError *error) {
        
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

@end

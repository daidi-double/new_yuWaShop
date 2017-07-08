//
//  VoiceChatViewController.m
//  雨掌柜
//
//  Created by double on 17/7/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "VoiceChatViewController.h"

@interface VoiceChatViewController ()<EMCallManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;

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
        _rejectBtn.hidden = !_isHidden;
        _answerBtn.hidden = !_isHidden;
        _hangupBtn.hidden = _isHidden;
    }
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_friendsIcon]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (!_callSession) {
        
        [[EMClient sharedClient].callManager startVoiceCall:_friendsHXID completion:^(EMCallSession *aCallSession, EMError *aError) {
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
    _nameLabel.text = _friendsName;
    _hangupBtn.hidden = !_isHidden;
    [self _startTimeTimer];
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
    
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
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
    [self _stopTimeTimer];
    _callSession = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)_startTimeTimer
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
    
    self.timeLabel.text = nil;
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
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:EMCallEndReasonDecline];
        _callSession = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//挂断
- (IBAction)hangupAction:(UIButton *)sender {
    [self _stopTimeTimer];
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:EMCallEndReasonHangup];
        _callSession = nil;
    }
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//接听
- (IBAction)answerAction:(UIButton *)sender {
    
    EMError * error = [[EMClient sharedClient].callManager answerIncomingCall:_callSession.sessionId];
    
    if (error) {
        
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:EMCallEndReasonFailed];
    }else{
        sender.hidden = YES;
        _rejectBtn.hidden = YES;
        _hangupBtn.hidden = NO;
    }
}

- (void)clearData
{
 
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    [audioSession setActive:YES error:nil];

    _callSession = nil;
    
    [self _stopTimeTimer];
    //    [self _stopRing];
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

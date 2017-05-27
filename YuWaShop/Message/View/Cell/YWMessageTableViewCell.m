//
//  YWMessageTableViewCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/27.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageTableViewCell.h"

#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseMessageViewController.h"
#import "NSDate+Category.h"
#import "EaseLocalDefine.h"

#import "JWTools.h"
@implementation YWMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.layer.cornerRadius = 25.f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.countLabel.layer.cornerRadius = 8.f;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.countLabel.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(EaseConversationModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.jModel.nikeName;
    
    if (self.model.conversation.unreadMessagesCount == 0) {
        self.countLabel.hidden = YES;
    }else{
        self.countLabel.hidden = NO;
        self.countLabel.text = [NSString stringWithFormat:@"%zi",(self.model.conversation.unreadMessagesCount <=99?self.model.conversation.unreadMessagesCount:99)];
    }
    
    self.timeLbael.text = [self latestMessageTimeForConversationModel:self.model];
    
    self.conLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[YWMessageTableViewCell latestMessageTitleForConversationModel:self.model] textFont:self.conLabel.font];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.jModel.header_img] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
}

#pragma mark - EaseUI Action
- (NSString *)latestMessageTimeForConversationModel:(EaseConversationModel *)conversationModel{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        latestMessageTime = [JWTools dateWithOutYearDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

+ (NSString *)latestMessageTitleForConversationModel:(EaseConversationModel *)conversationModel{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

@end

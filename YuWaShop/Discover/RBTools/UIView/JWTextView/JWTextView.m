//
//  MDTextView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWTextView.h"

@implementation JWTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isDrawPlaceholder = YES;
        self.placeholderColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:15.f];
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isDrawPlaceholder = YES;
        self.placeholderColor = [UIColor lightGrayColor];
        self.font = [UIFont systemFontOfSize:15.f];
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDrawPlaceholder = YES;
        self.placeholderColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:16.f];
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textViewTextDidChange:(NSNotification *)notification{
    self.isDrawPlaceholder = NO;
    if ([self.text isEqualToString:@""]) {
        self.isDrawPlaceholder = YES;
    }
    [self setNeedsDisplay];
    return;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.isDrawPlaceholder) {
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.placeholderColor};
    
    [self.placeholder drawInRect:(CGRect){6,8,rect.size.width - 16,rect.size.height - 16} withAttributes:attributes];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
@end

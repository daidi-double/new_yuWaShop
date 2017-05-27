//
//  MDTextView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTextView : UITextView
@property(nonatomic, assign)BOOL isDrawPlaceholder;
@property(nonatomic, copy)NSString *placeholder;
@property(nonatomic, strong)UIColor *placeholderColor;

@end

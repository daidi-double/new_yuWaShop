//
//  PassWordTextView.h
//  YuWaShop
//
//  Created by double on 17/3/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordTextView : UIView
/**
 the password is user inputed
 */
@property (nonatomic, copy) void(^passwordDidChangeBlock)(NSString *password);

@property (nonatomic,copy) void(^passWordTextViewBlock)();
/**
 set element count, default is 4, remove all elements and creat new elemets when it was set
 */
@property (nonatomic, assign) NSInteger elementCount;

/**
 set element color, default is balck color
 */
@property (nonatomic, strong) UIColor *elementBorderColor;

/**
 set element margein, default is 4 point
 */
@property (nonatomic, assign) CGFloat elementMargin;

/**
 auto hide the keyboard when input password was completed, default is YES
 */
@property (nonatomic, assign) BOOL autoHideKeyboard;

/**
 set element border width, default's 1 point
 */
@property (nonatomic, assign) CGFloat elementBorderWidth;

/**
 clear all password
 */
- (void)clearPassword;


- (void)showKeyboard;

- (void)hideKeyboard;
@end

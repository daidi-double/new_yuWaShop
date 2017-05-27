//
//  XHBranchTextView.h
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHTagHeader.h"

@interface XHBranchTextView : UIView

/**
 *  分支提示文本
 */
@property (nonatomic, copy) NSString *branchText;

- (void)showInPoint:(CGPoint)point direction:(XHBranchLayerDirection)direction;
- (void)dismiss;

@end
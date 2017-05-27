//
//  ForgetPayPasswordTableViewCell.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ForgetPayPasswordTableViewCell.h"

@implementation ForgetPayPasswordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.infoTextfiled addTarget:self action:@selector(textLenghChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
}
- (void)textLenghChange:(UITextField *)textField{
    NSString *phone = textField.text;
    MyLog(@"status = %ld",self.status);
    if (self.status == 0) {
        //        if (phone.length == 19)
        //        {
        //
        //            self.phoneTextViewBlock(phone);
        //
        //        }
    }else if (self.status == 1){
        
        
    }else{
        
        if (phone.length == 11)
        {
            
            self.phoneTextViewBlock(phone);
            
        }
        
    }
    
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

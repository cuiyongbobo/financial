//
//  PersonalInformationTableViewCell.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "PersonalInformationTableViewCell.h"

@implementation PersonalInformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //添加边框
    CALayer * layer = [self.QrcodeImageView layer];
    layer.borderColor = [[UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1] CGColor];
    layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

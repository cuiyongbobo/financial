//
//  SYMNewAssetReflectTableViewCell.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMNewAssetReflectTableViewCell.h"
#import "SYMConstantCenter.h"

@implementation SYMNewAssetReflectTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //给iamgeview添加边框
    //添加边框
    CALayer * layer = [_imgvPhoto layer];
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    layer.borderWidth = 0.3f;
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:5.0];
    // 扩大范围
    [self.ProvinceButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [self.CityButton pointInside:CGPointMake(300, 300) withEvent:nil];
}

-(void)createCellViewsWithItemInfo:(BOOL)isOpe{
    
    if (isOpe) {
        self.viewHeight.constant=113*SYMHEIGHTRATESCALE;
        [_bdView setHidden:NO];
        _imgvPhoto.layer.borderColor = [[UIColor blueColor] CGColor];
        [_clickbutton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    }else{
        [_bdView setHidden:YES];
        self.viewHeight.constant=0;
        _imgvPhoto.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        [_clickbutton setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

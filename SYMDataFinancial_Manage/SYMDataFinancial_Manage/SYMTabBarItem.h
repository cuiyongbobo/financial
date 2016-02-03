//
//  SYMTabBarItem.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/4.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMTabBarItem : UIView

@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (weak, nonatomic) IBOutlet UIImageView *tabBarImage;
@property (weak, nonatomic) IBOutlet UILabel *tabBarTitle;
@property (weak, nonatomic) IBOutlet UIImageView *tabBarTipsImage;

@end

//
//  SYMHomeViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "VWWWaterView.h"

@interface SYMHomeViewController : MainViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BannerHightConstra;
@property (weak, nonatomic) IBOutlet UIImageView *CheckDetailsImageView;
@property (weak, nonatomic) IBOutlet UILabel *ShowTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *DisplayListHeight;
@property (weak, nonatomic) IBOutlet UILabel *CastLabel;
@property (weak, nonatomic) IBOutlet UILabel *PoundageLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberPoundageLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *LimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *StandardProfitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BDAdditional;
@property (weak, nonatomic) IBOutlet UILabel *AdditionalBenefitLabel;
@property (weak, nonatomic) IBOutlet UILabel *PercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddLabel;
@property (weak, nonatomic) IBOutlet UIButton *MakeMoneybutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Leftwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Centerwidth;

- (IBAction)btnClick:(id)sender;
@end

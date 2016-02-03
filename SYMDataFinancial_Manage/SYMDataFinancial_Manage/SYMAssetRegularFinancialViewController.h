//
//  SYMAssetRegularFinancialViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/24.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMAssetRegularFinancialViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIScrollView *HeaderScrollerView;
@property (weak, nonatomic) IBOutlet UIPageControl *PageControlS;
@property (weak, nonatomic) IBOutlet UITableView *BDTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BannerHightConstra;
@property (weak, nonatomic) IBOutlet UILabel *ReflectBalance;
@property (weak, nonatomic) IBOutlet UIButton *Reflectbutton;
@property (weak, nonatomic) IBOutlet UILabel *emptyData;


- (IBAction)BtnClick:(id)sender;
@end

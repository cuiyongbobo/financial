//
//  SYMAssetReflectViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMCustomButton.h"

@interface SYMAssetReflectViewController : MainViewController

@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollerView;
@property (weak, nonatomic) IBOutlet UILabel *CanreflectLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameNumber;
@property (weak, nonatomic) IBOutlet UILabel *ReflectMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *BankcardLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
@property (weak, nonatomic) IBOutlet UITextField *BranchName;
@property (weak, nonatomic) IBOutlet UILabel *RENameNumber;
@property (weak, nonatomic) IBOutlet UILabel *REReflectMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *REBankcardLabel;
@property (weak, nonatomic) IBOutlet SYMCustomButton *ProvinceButton;
@property (weak, nonatomic) IBOutlet SYMCustomButton *CityButton;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;


-(IBAction)ClickBtn:(id)sender;
@end

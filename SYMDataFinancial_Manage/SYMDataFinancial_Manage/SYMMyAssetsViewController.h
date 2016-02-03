//
//  SYMMyAssetsViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMMyAssetsViewController : MainViewController
@property (weak, nonatomic) IBOutlet UITableView *BDTableView;
@property (weak, nonatomic) IBOutlet UILabel *TotalAssets;

@end

//
//  SYMAssetReflectViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMCustomButton.h"

@interface SYMNewAssetReflectViewController : MainViewController
@property (weak, nonatomic) IBOutlet UILabel *CanreflectLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


-(IBAction)ClickBtn:(id)sender;
@end

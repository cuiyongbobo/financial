//
//  SYMPersonalCenterViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/4.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMCustomButton.h"

@interface SYMPersonalCenterViewController : MainViewController

@property (weak, nonatomic) IBOutlet UILabel *ShowInformation;
@property (weak, nonatomic) IBOutlet SYMCustomButton *SendButton;
@property (weak, nonatomic) IBOutlet UITableView *PersonTable;

- (IBAction)btnClick:(id)sender;
@end

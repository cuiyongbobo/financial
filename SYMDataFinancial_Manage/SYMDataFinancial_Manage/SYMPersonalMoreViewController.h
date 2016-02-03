//
//  SYMPersonalMoreViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/10.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMPersonalMoreViewController : MainViewController
@property (weak, nonatomic) IBOutlet UITableView *PersonalMoreTable;

- (IBAction)ClickLogout:(id)sender;
@end

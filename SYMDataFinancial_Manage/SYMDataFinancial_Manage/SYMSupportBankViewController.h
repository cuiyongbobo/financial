//
//  SYMSupportBankViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/18.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMSupportBankViewController : MainViewController

@property (weak, nonatomic) IBOutlet UITableView *BDInformationTable;
@property (nonatomic,copy) NSString *distributorCode;
@end

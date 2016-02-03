//
//  SYMBindingBankcardViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/26.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMBindingBankcardViewController : MainViewController
@property (weak, nonatomic) IBOutlet UITableView *BDtableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;
@end

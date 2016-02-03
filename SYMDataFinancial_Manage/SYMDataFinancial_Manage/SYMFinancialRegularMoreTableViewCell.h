//
//  SYMFinancialRegularMoreTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/23.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"

@interface SYMFinancialRegularMoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CustomSwitch *Switch;
@property (weak, nonatomic) IBOutlet UILabel *ProductName;
@property (weak, nonatomic) IBOutlet UILabel *buyInMoney;
@property (weak, nonatomic) IBOutlet UILabel *Interestdue;
@property (weak, nonatomic) IBOutlet UILabel *Duetime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Rightwidth;

@end

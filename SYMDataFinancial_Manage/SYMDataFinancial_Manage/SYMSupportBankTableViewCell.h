//
//  SYMSupportBankTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/18.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMSupportBankTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (weak, nonatomic) IBOutlet UILabel *information;

@property (weak, nonatomic) IBOutlet UILabel *informationMoney;

@property (weak, nonatomic) IBOutlet UILabel *informationMore;


@end

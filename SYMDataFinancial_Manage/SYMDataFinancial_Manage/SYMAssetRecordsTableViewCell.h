//
//  SYMAssetRecordsTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMAssetRecordsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ThemeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ShowTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TransactionAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TransactionStatusLabel;

@end

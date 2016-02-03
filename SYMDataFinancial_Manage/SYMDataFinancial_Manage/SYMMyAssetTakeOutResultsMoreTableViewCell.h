//
//  SYMMyAssetTakeOutResultsMoreTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMMyAssetTakeOutResultsMoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *cashMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;
@property (weak, nonatomic) IBOutlet UIImageView *FailResultImageview;

@end

//
//  SYMChoicenessStyleTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/15.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMChoicenessStyleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PeriodNumber;
@property (weak, nonatomic) IBOutlet UILabel *AnnualEarnings;
@property (weak, nonatomic) IBOutlet UILabel *TimeLimit;
@property (weak, nonatomic) IBOutlet UILabel *Balance;
@property (weak, nonatomic) IBOutlet UIButton *MakeMoney;
@property (weak, nonatomic) IBOutlet UILabel *TimeUnit;
@property (weak, nonatomic) IBOutlet UILabel *ProductName;
@property (weak, nonatomic) IBOutlet UILabel *LabelName;
@property (weak, nonatomic) IBOutlet UIImageView *ShowLabelImageview;
@property (weak, nonatomic) IBOutlet UILabel *AdditionalBenefitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *additionalImageView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Leftwidth;

@end

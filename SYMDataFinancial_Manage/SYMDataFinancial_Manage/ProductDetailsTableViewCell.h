//
//  ProductDetailsTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIProgressView *DetailProgress;
@property (weak, nonatomic) IBOutlet UILabel *SaleTotalBalance;
@property (weak, nonatomic) IBOutlet UILabel *remainingTotalBalance;
@property (weak, nonatomic) IBOutlet UILabel *ProgressPercentage;

@end

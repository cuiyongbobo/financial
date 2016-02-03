//
//  DailyInterestTreasureTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/18.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyInterestTreasureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ShowProgress;

@property (weak, nonatomic) IBOutlet UILabel *depositMoney;

@property (weak, nonatomic) IBOutlet UISlider *mySlider;

@property (weak, nonatomic) IBOutlet UILabel *earnings;

@property (weak, nonatomic) IBOutlet UILabel *BankDeposit;


@end

//
//  SYMAssetTransactionRecordViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMCustomButton.h"

@interface SYMAssetTransactionRecordViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeaderHeightConstr;
@property (weak, nonatomic) IBOutlet UIImageView *HeaderImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AccordWidth;
@property (weak, nonatomic) IBOutlet UIImageView *SliderImageView;
@property (weak, nonatomic) IBOutlet SYMCustomButton *BuyIn;
@property (weak, nonatomic) IBOutlet SYMCustomButton *Withdrawal;


-(IBAction)slider:(id)sender;
@end

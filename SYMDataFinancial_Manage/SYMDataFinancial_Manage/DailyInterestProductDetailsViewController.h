//
//  RegularProductDetailsViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMCustomButton.h"

@interface DailyInterestProductDetailsViewController : MainViewController

@property (weak, nonatomic) IBOutlet UITableView *ProductDetailsTableView;

@property (weak, nonatomic) IBOutlet UITextField *InputInvestment;

@property (weak, nonatomic) IBOutlet UIButton *depositFunction;

@property (weak, nonatomic) IBOutlet UIView *promptDetailBD;

@property (weak, nonatomic) IBOutlet SYMCustomButton *ContinueCast;

@property (weak, nonatomic) IBOutlet SYMCustomButton *redemption;

@property (weak, nonatomic) IBOutlet UILabel *matures;


-(IBAction)switchstate:(id)sender;

- (IBAction)depositClick:(id)sender;

@end

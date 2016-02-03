//
//  SYMTiedCardViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/24.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMDataBaseModel.h"
#import "MainViewController.h"

@interface SYMTiedCardViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollView;
//@property (weak, nonatomic) IBOutlet UILabel *AmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@property (weak, nonatomic) IBOutlet UITextField *IdNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *CardNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *CardNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
@property (nonatomic,strong)OpenAccount *acconutmodel;
@property (nonatomic,copy) NSString *Tiedstatus;
@property (nonatomic,copy) NSString *InvestmentAmount;
@property (nonatomic,strong)CustomerInformation *customerModel;
@property (weak, nonatomic) IBOutlet UITextField *AmountLabel;
@property (nonatomic,strong) ProductDetails *detailModel;

-(IBAction)btnClick:(id)sender;
@end

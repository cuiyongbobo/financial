//
//  LoginViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMDataBaseModel.h"
#import "SYMCustomButton.h"
typedef void (^SetPaypassBack)(void);
@interface SYMSetPaypasswordViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIImageView *BDImageView;
@property (weak, nonatomic) IBOutlet UITextField *IPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet SYMCustomButton *ShowPassbutton;
@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollView;
@property (nonatomic,strong)CustomerInformation *customerModel;
@property (nonatomic,copy) SetPaypassBack backpaypassword;
@property (nonatomic,strong)OpenAccount *accomodel;
@property (nonatomic,copy) NSString *amount;

-(IBAction)btnClick:(id)sender;
@end

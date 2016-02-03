//
//  LoginViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMBackPasswordViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIImageView *BDImageView;
@property (weak, nonatomic) IBOutlet UITextField *IPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollView;
@property (weak, nonatomic) IBOutlet UITextField *NewInformationTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

-(IBAction)btnClick:(id)sender;
@end

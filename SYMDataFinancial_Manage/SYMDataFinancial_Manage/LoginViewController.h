//
//  LoginViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
typedef void (^LoginBack)(void);
@interface LoginViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIImageView *BDImageView;
@property (weak, nonatomic) IBOutlet UITextField *IPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *ShowPassbutton;
@property (weak, nonatomic) IBOutlet UIScrollView *BDScrollView;
@property (nonatomic,copy) LoginBack backLogin;

-(IBAction)btnClick:(id)sender;
@end

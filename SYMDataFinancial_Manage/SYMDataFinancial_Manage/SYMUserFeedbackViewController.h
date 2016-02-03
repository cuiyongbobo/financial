//
//  SYMUserFeedbackViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMUserFeedbackViewController : MainViewController
@property (weak, nonatomic) IBOutlet UITextView *TextViewInput;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldInput;
@property (weak, nonatomic) IBOutlet UIButton *Submit;
@property (weak, nonatomic) IBOutlet UIView *BDView;

- (IBAction)ClickSubmit:(id)sender;

@end

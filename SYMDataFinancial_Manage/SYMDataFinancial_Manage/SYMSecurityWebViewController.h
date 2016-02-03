//
//  SYMSecurityWebViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/27.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMDataBaseModel.h"
#import "MainViewController.h"

@interface SYMSecurityWebViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIWebView *BDWebView;
@property (nonatomic,copy) NSString *descriptions;
@property (nonatomic,copy) NSString *weburl;
@property (nonatomic,weak) IBOutlet UIButton *changebutton;
@property (nonatomic,strong) Buyproduct *model;

- (IBAction)btnClick:(id)sender;
@end

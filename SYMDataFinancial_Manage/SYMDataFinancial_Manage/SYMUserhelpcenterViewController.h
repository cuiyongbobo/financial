//
//  SYMUserhelpcenterViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"

@interface SYMUserhelpcenterViewController : MainViewController
@property (weak, nonatomic) IBOutlet UIWebView *BDWebView;
@property (nonatomic,copy) NSString *weburl;
@end

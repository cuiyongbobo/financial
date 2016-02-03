//
//  SYMAddProductDetailsewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/26.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMDataBaseModel.h"

@interface SYMAddProductDetailsewController : MainViewController
@property (weak, nonatomic) IBOutlet UITableView *BDTableView;
@property (nonatomic,strong) ProductDetails *model;
@property (nonatomic,copy) NSString *startTimer;
@property (nonatomic,copy) NSString *endTiner;
@property (weak, nonatomic) IBOutlet UIWebView *BDWebView;

@end

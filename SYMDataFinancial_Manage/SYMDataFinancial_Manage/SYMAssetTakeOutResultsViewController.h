//
//  SYMAssetTakeOutResultsViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
@interface SYMAssetTakeOutResultsViewController : MainViewController
@property (weak, nonatomic) IBOutlet UITableView *BDAssetTableView;
@property (nonatomic,strong) NSMutableArray *drawalresultArray;

-(IBAction)btnclick:(id)sender;
@end

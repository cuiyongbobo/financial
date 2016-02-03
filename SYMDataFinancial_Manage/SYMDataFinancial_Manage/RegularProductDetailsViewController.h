//
//  RegularProductDetailsViewController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMCustomButton.h"
#import "SYMDataBaseModel.h"

@interface RegularProductDetailsViewController : MainViewController

@property (weak, nonatomic) IBOutlet UITableView *ProductDetailsTableView;
@property (weak, nonatomic) IBOutlet UITextField *InputInvestment;
@property (weak, nonatomic) IBOutlet UIButton *depositFunction;
@property (weak, nonatomic) IBOutlet UIView *promptDetailBD;
@property (weak, nonatomic) IBOutlet SYMCustomButton *ContinueCast;
@property (weak, nonatomic) IBOutlet SYMCustomButton *redemption;
@property (weak, nonatomic) IBOutlet UILabel *matures;
@property (nonatomic,strong) ProductList *productModel;
@property (weak, nonatomic) IBOutlet UILabel *ProductName;
@property (weak, nonatomic) IBOutlet UILabel *Labelone;
@property (weak, nonatomic) IBOutlet UILabel *LabeSecond;
@property (weak, nonatomic) IBOutlet UILabel *LabeThird;
@property (weak, nonatomic) IBOutlet UILabel *StandardEarning;
@property (weak, nonatomic) IBOutlet UILabel *additionalEarning;
@property (nonatomic,copy) NSString *status;
@property (weak, nonatomic) IBOutlet UIImageView *BDAddImageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Leftwidth;
@property (weak, nonatomic) IBOutlet UILabel *addlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightwidth;
@property (weak, nonatomic) IBOutlet UILabel *symbollabel;
@property (weak, nonatomic) IBOutlet UILabel *TitleInformation;
@property (weak, nonatomic) IBOutlet SYMCustomButton *xutoubutton;
@property (weak, nonatomic) IBOutlet UILabel *xutouLabel;
@property (weak, nonatomic) IBOutlet SYMCustomButton *shuhuibutton;
@property (weak, nonatomic) IBOutlet UILabel *shuhuiLabel;


-(IBAction)switchstate:(id)sender;
-(IBAction)depositClick:(id)sender;
@end

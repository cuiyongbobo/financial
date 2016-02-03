//
//  SYMNewAssetReflectTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMCustomButton.h"
@interface SYMNewAssetReflectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *clickbutton;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPhoto;
@property (weak, nonatomic) IBOutlet UIView *bdView;
@property (weak, nonatomic) IBOutlet UILabel *ReflectMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *BankcardLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *CityLabel;
@property (weak, nonatomic) IBOutlet UITextField *BranchName;
@property (weak, nonatomic) IBOutlet SYMCustomButton *ProvinceButton;
@property (weak, nonatomic) IBOutlet SYMCustomButton *CityButton;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;


-(void)createCellViewsWithItemInfo:(BOOL)isOpe;
@end

//
//  SYMBindCardTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/18.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMBindCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BankIcon;
@property (weak, nonatomic) IBOutlet UILabel *BankName;
@property (weak, nonatomic) IBOutlet UILabel *BankNo;

@end

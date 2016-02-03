//
//  PersonalInformationTableViewCell.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IdCard;
@property (weak, nonatomic) IBOutlet UILabel *IphoneNo;
@property (weak, nonatomic) IBOutlet UIImageView *QrcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *selfCode;

@end

//
//  SYMInformationSave.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/8.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYMDataBaseModel.h"
@interface SYMInformationSave : NSObject
+(SYMInformationSave *)defaultSaveInformation;
@property (nonatomic,strong) ProductDetails *detailModel;
@property (nonatomic,copy) NSString *isstate;
@end

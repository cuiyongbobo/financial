//
//  SYMInformationSave.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/8.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMInformationSave.h"

@implementation SYMInformationSave
+(SYMInformationSave *)defaultSaveInformation
{
    static SYMInformationSave *information=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        information=[[SYMInformationSave alloc]init];
    });
    return information;
}
@end

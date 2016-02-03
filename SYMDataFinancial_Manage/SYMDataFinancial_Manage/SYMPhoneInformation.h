//
//  SYMPhoneInformation.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/7.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SYMPhoneInformation : NSObject
+(SYMPhoneInformation *)sharePhoneInformation;
-(NSDictionary *)getinfo;
@end

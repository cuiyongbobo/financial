//
//  UIColor+Hex.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/4.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+(UIColor *)colorWithHexString:(NSString *)color;
+(UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end

//
//  BtmMobile.h
//  AutomaticMobile
//
//  Created by cuiyong on 15/9/22.
//  Copyright (c) 2015年 cuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BtmMobile : NSObject

+(BtmMobile *)shareBtmMoile;

-(void)startMove:(UIViewController *)control;

-(void)stopMove;

-(void)stopTimer;

@end

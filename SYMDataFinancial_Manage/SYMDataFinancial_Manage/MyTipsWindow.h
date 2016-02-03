//
//  MyTipsWindow.h
//  AutoLayout
//
//  Created by cuiyong on 15/5/29.
//  Copyright (c) 2015年 cuiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    white=1,
    black,
} backgroundcolor;
@interface MyTipsWindow : UIWindow

+(MyTipsWindow *)shareMytipview;
-(void)HiddenTipView:(BOOL)value viewcontroller:(UIViewController *)viewcontroller tiptext:(NSString *)tiptext backgroundcolor:(backgroundcolor)backgroundcolor;
@end

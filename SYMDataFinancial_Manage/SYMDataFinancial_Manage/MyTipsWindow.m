//
//  MyTipsWindow.m
//  AutoLayout
//
//  Created by cuiyong on 15/5/29.
//  Copyright (c) 2015年 cuiyong. All rights reserved.
//

#import "MyTipsWindow.h"
#import "SYMConstantCenter.h"

@interface MyTipsWindow ()
{
    UIImageView *Tipimageview;
    NSTimer *MyTimer;
}
@end

@implementation MyTipsWindow

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+(MyTipsWindow *)shareMytipview
{
    static MyTipsWindow *tipview=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipview=[[MyTipsWindow alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-230/2,[UIScreen mainScreen].bounds.size.height-100*SYMHEIGHTRATESCALE, 230*SYMWIDthRATESCALE, 32*SYMHEIGHTRATESCALE)];
    });
    tipview.backgroundColor=[UIColor clearColor];
    tipview.windowLevel = UIWindowLevelAlert;
    [tipview makeKeyAndVisible];
    return tipview;
}

-(void)HiddenTipView:(BOOL)value viewcontroller:(UIViewController *)viewcontroller tiptext:(NSString *)tiptext backgroundcolor:(backgroundcolor)backgroundcolor
{
    if (Tipimageview == nil) {
        Tipimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,230*SYMWIDthRATESCALE,32*SYMHEIGHTRATESCALE)];
        //Tipimageview=[[UIImageView alloc]init];
        //自适应图片宽高比例
        if (tiptext.length>9) {
        }else{
            Tipimageview.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    if (!value) {
        if (backgroundcolor==1) {
            Tipimageview.image=[UIImage imageNamed:@"public_tips_black"];
        }else{
            Tipimageview.image=[UIImage imageNamed:@"public_tips_white"];
        }
        UILabel *label;
        if ([[Tipimageview subviews] count] > 0 ) {
            label = [Tipimageview subviews][0];
        }
        else{
            label=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 230*SYMWIDthRATESCALE, 30*SYMHEIGHTRATESCALE)];
            //label.frame=Tipimageview.bounds;
        }
        
        label.text=tiptext;
        label.textAlignment = NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[[UIColor alloc]initWithRed:255.0 green:255.0 blue:255.0 alpha:1];
        [Tipimageview addSubview:label];
        [self addSubview:Tipimageview];
    }
    if ([MyTimer isValid]) {
        [MyTimer invalidate];
        MyTimer =nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MyTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(functonstips) userInfo:nil repeats:NO];
    });
}

-(void)functonstips
{
    [Tipimageview removeFromSuperview];
    Tipimageview=nil;
    self.hidden=YES;
    if ([MyTimer isValid]) {
        [MyTimer invalidate];
        MyTimer =nil;
    }
}

@end

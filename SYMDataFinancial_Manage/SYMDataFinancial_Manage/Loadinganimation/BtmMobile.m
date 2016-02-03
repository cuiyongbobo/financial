//
//  BtmMobile.m
//  AutomaticMobile
//
//  Created by cuiyong on 15/9/22.
//  Copyright (c) 2015年 cuiyong. All rights reserved.
//

#import "BtmMobile.h"
#import "SYMLoading.h"

#define MainScreenWith [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

typedef enum : NSUInteger {
    pictureONE=200,
    pictureSecond,
    pictureThird,
}Type;

@interface BtmMobile ()
{
    
    NSTimer *mytimer;
    CGPoint center;
    CGPoint saveCenter;
    UIImageView * moveImageview;
    SYMLoading *loading;
    NSInteger isStart;
    UIViewController *_mainController;
}
@end

@implementation BtmMobile

+(BtmMobile *)shareBtmMoile{
    
    static BtmMobile *mobile=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mobile=[[BtmMobile alloc]init];
    });
    return mobile;
}

-(void)startMove:(UIViewController *)control{
    _mainController=control;
    isStart=pictureONE;
    loading=[[[NSBundle mainBundle]loadNibNamed:@"SYMLoading" owner:self options:nil]lastObject];
    _mainController.view.userInteractionEnabled=NO;
    loading.frame=control.view.bounds;
    loading.backgroundColor = [UIColor clearColor];
    [loading.MoneyImageViewLeft setHidden:NO];
    [loading.MoneyImageViewCenter setHidden:YES];
    [loading.MoneyImageViewRight setHidden:YES];
    [control.view addSubview:loading];
    [self startTimer];
}

-(void)handleTimer:(NSTimer *)timer{
    [self reStart];
}

-(void)startTimer{
    mytimer=[NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

-(void)reStart{
    
    switch (isStart) {
        case pictureONE:
        {
            if (center.y==saveCenter.y) {
                moveImageview=loading.MoneyImageViewLeft;
                center=loading.MoneyImageViewLeft.center;
                saveCenter=loading.MoneyImageViewLeft.center;
            }
            if (center.y>=loading.MoneyPurse.frame.origin.y+loading.MoneyImageViewLeft.frame.size.height*(6/31)) {
                [UIView animateWithDuration:0.2 animations:^{
                    center=saveCenter;
                    center.y=saveCenter.y;
                    moveImageview.center=saveCenter;
                }];
                
                [loading.MoneyImageViewLeft setHidden:YES];
                [loading.MoneyImageViewCenter setHidden:YES];
                [loading.MoneyImageViewRight setHidden:NO];
                isStart=pictureThird;
                [self reStart];
                
            }else{
                
                [UIView animateWithDuration:0.2 animations:^{
                    center.y+=1;
                    center.x+=1;
                    moveImageview.center=center;
                }];
            }
        }
            break;
        case pictureSecond:
        {
            
            if (center.y==saveCenter.y) {
                moveImageview=loading.MoneyImageViewCenter;
                center=loading.MoneyImageViewCenter.center;
                saveCenter=loading.MoneyImageViewCenter.center;
            }
            
            if (center.y>=loading.MoneyPurse.frame.origin.y+loading.MoneyImageViewLeft.frame.size.height*(6/29)) {
                [UIView animateWithDuration:0.2 animations:^{
                    center=saveCenter;
                    center.y=saveCenter.y;
                    moveImageview.center=saveCenter;
                }];
                
                [loading.MoneyImageViewLeft setHidden:NO];
                [loading.MoneyImageViewCenter setHidden:YES];
                [loading.MoneyImageViewRight setHidden:YES];
                isStart=pictureONE;
                [self reStart];
                
            }else{
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    center.y+=1;
                    //center.x+=1;
                    moveImageview.center=center;
                }];
            }
        }
            break;
        case pictureThird:
        {
            
            if (center.y==saveCenter.y) {
                moveImageview=loading.MoneyImageViewRight;
                center=loading.MoneyImageViewRight.center;
                saveCenter=loading.MoneyImageViewRight.center;
            }
            
            if (center.y>=loading.MoneyPurse.frame.origin.y+loading.MoneyImageViewLeft.frame.size.height*(6/24)) {
                [UIView animateWithDuration:0.2 animations:^{
                    center=saveCenter;
                    center.y=saveCenter.y;
                    moveImageview.center=saveCenter;
                }];
                
                [loading.MoneyImageViewLeft setHidden:YES];
                [loading.MoneyImageViewCenter setHidden:NO];
                [loading.MoneyImageViewRight setHidden:YES];
                isStart=pictureSecond;
                [self reStart];
                
            }else{
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    center.y+=1;
                    center.x+=-0.8;
                    moveImageview.center=center;
                }];
            }
        }
            break;
        default:
            break;
    }
}


-(void)stopMove{
    
    if ([mytimer isValid]) {
        [mytimer invalidate];
        mytimer=nil;
    }
    [loading removeFromSuperview];
    loading=nil;
    center=CGPointMake(0, 0);
    saveCenter=CGPointMake(0, 0);
    _mainController.view.userInteractionEnabled=YES;
    [_mainController.view.layer removeAllAnimations];
    
}

-(void)stopTimer
{
    [mytimer invalidate];
    mytimer=nil;
}



@end

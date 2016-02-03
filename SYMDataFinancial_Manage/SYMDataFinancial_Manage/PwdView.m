//
//  PwdView.m
//  BitMainWallet_Hot
//
//  Created by cuiyong on 15/6/23.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import "PwdView.h"

#define iPhone4 [UIScreen mainScreen].bounds.size.height

@interface PwdView ()
{
    NSInteger count1;
}

@end

@implementation PwdView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)drawRect:(CGRect)rect
{
    //分割线
    CGFloat gridWidth = rect.size.width/self.pwdCount;
    CGFloat gridHeight = rect.size.height;
    
    if (iPhone4 == 480.0) {
        gridHeight = gridWidth;
    }
    for (int i = 0; i < self.pwdCount; i++) {
        
        CGContextRef  ctx = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctx, gridWidth * (i + 1), 0);
        CGContextAddLineToPoint(ctx, gridWidth * (i + 1), gridHeight);
        //CGContextSetRGBStrokeColor(ctx, 134/255.0f, 139/255.0f, 142/255.0f, 0.7);
        CGContextSetRGBStrokeColor(ctx, 204/255.0f, 204/255.0f, 204/255.0f, 1);
        CGContextStrokePath(ctx);
    }
    //画点
    CGContextRef  ctxPoint = UIGraphicsGetCurrentContext();
    CGFloat pointY = rect.size.height/2;
    for (int i = 0; i <count1; i++) {
        CGContextAddArc(ctxPoint, gridWidth/2 + i * gridWidth, pointY, 5, 0, M_PI  *2, 1);
        CGContextFillPath(ctxPoint);
    }
}

//正常情况下 drawRect只会调用一次 输入框的文字每变化一次，
//我们就需要调用[self setNeedsDisplay]; 重新执行drawRect方法
- (void)setCount:(NSInteger)count{
    NSLog(@"调用了PwdView的 - setCount - 方法");
    count1 = count;
    [self setNeedsDisplay];
}



@end

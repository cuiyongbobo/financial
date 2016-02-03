//
//  SYMCustomButton.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/9.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMCustomButton.h"
#import "SYMConstantCenter.h"

@implementation SYMCustomButton


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //
        self.titleLabel.font = [UIFont systemFontOfSize:[self.titleLabel.font pointSize]*SYMHEIGHTRATESCALE];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self createButton];
    }
    return self;
}

//附带一个文本信息的按钮
-(void)createButton
{
    _rightLabel = [[UILabel alloc]init];
    _rightLabel.text = @"999999";
    _rightLabel.textColor = [UIColor whiteColor];
    _rightLabel.userInteractionEnabled = YES;
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_rightLabel];
}

/*
 普通初始化放法
 */
- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithTitleColor:(UIColor *) color WithTag:(NSInteger) tag WithTarget:(id)target WithAction:(SEL)action WithBgImage:(NSString *)image WithHighLightedImage:(NSString *)highImage WithFont:(CGFloat)font
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTag:tag];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    return self;
}

/*
 添加设置左边图标,右面图片方法
 */
- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithTitleColor:(UIColor *) color WithTitleFrame:(CGRect)frame2 WithTag:(NSInteger) tag WithTarget:(id)target WithAction:(SEL)action WithLeftFrame:(CGRect)frame3 WithLeftImage:(NSString *)leftImage WithBgImage:(NSString *)image WithHighLightedImage:(NSString *)highImage WithFont:(CGFloat)font
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        
        //圆角
        //        self.layer.cornerRadius = 3;
        //        self.clipsToBounds = YES;
        [self setTag:tag];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
        
        
        //文字
        UILabel * rightLabel = [[UILabel alloc]init];
        rightLabel.frame = frame2;
        rightLabel.text = title;
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont boldSystemFontOfSize:font];
        //        rightLabel.userInteractionEnabled = YES;//此处注意不要加这个
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:rightLabel];
        
        
        //图标
        UIImageView *limage = [[UIImageView alloc]initWithFrame:frame3];
        limage.image = [UIImage imageNamed:leftImage];
        [self addSubview:limage];
        
    }
    return self;
}

/*
 类方法普通初始化
 */
+ (id)buttonWithType:(UIButtonType)buttonType Frame:(CGRect)frame Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action  BgImage:(NSString *)image HighLightedImage:(NSString *)highImage Font:(CGFloat)font

{
    UIButton *button = [super buttonWithType:buttonType];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];//边界限定top, left, bottom, right
    [button setFrame:frame];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:font]];//此处font为系统样式
    [button setTag:tag];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    return button;
}

/*
 添加设置选择状态图片
 */
+ (id)buttonWithType:(UIButtonType)buttonType Frame:(CGRect)frame Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action  BgImage:(NSString *)image HighLightedImage:(NSString *)highImage
       SelectedImage:(NSString*)selectedImage Font:(CGFloat)font
{
    UIButton *button = [super buttonWithType:buttonType];
    [button setFrame:frame];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:font]];//此处font为系统样式
    [button setTag:tag];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    return button;
}



- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(100.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(50.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

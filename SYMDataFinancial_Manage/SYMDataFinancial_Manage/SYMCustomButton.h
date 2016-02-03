//
//  SYMCustomButton.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/9.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMCustomButton : UIButton
@property (nonatomic,retain) UILabel *rightLabel;
/*
 普通初始化放法
 */
- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithTitleColor:(UIColor *) color WithTag:(NSInteger) tag WithTarget:(id)target WithAction:(SEL)action WithBgImage:(NSString *)image WithHighLightedImage:(NSString *)highImage WithFont:(CGFloat)font;

/*
 添加设置左边图标,右面图片方法
 */
- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithTitleColor:(UIColor *) color WithTitleFrame:(CGRect)frame2 WithTag:(NSInteger) tag WithTarget:(id)target WithAction:(SEL)action WithLeftFrame:(CGRect)frame3 WithLeftImage:(NSString *)leftImage WithBgImage:(NSString *)image WithHighLightedImage:(NSString *)highImage WithFont:(CGFloat)font;

/*
 类方法普通初始化
 */
+ (id)buttonWithType:(UIButtonType)buttonType Frame:(CGRect)frame Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action  BgImage:(NSString *)image HighLightedImage:(NSString *)highImage Font:(CGFloat)font;

/*
 添加设置选择状态图片
 */
+ (id)buttonWithType:(UIButtonType)buttonType Frame:(CGRect)frame Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action  BgImage:(NSString *)image HighLightedImage:(NSString *)highImage
       SelectedImage:(NSString*)selectedImage Font:(CGFloat)font;
@end

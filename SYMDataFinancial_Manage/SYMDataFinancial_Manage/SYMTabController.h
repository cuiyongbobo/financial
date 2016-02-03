//
//  SYMTabController.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYMTabController : UITabBarController


@property (nonatomic,strong) UITabBar * myTabBar;
@property (nonatomic,strong) NSArray *tabbarImageNormal;
@property (nonatomic,strong) NSArray *tabbarImageSelect;
@property (nonatomic,strong) NSArray *titleArray;

+(UITabBarController *)createTabViewController;
+(void)updateViewControllers:(UITabBarController *)tabBarController;
+(void)enableControllers:(UITabBarController *)myTabBarController Number:(NSArray *)numbers enable:(BOOL)enable;//设置可点击状态

//设置提醒
-(void)noticeWithViewControllerNumber:(NSInteger)vcNum;
//取消提醒
-(void)noticeCancelWithViewControllerNumber:(NSInteger)vcNum;
//隐藏
-(void)hidenTabBar:(BOOL)isHiden;
//设置当前选中
-(void)setCurrentSelectIndex:(NSInteger)selectedIndex;



@end

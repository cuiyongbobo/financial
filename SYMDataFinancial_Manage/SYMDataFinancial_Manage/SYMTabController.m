//
//  SYMTabController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "SYMTabController.h"
#import "SYMNavViewController.h"
#import "SYMTabViewControllers.h"
#import "SYMTabBarItem.h"
#import "SYMNavViewController.h"
#import "UIColor+Hex.h"
#import "SYMConstantCenter.h"

#define TABBARTAG 1000
#define TABTITLENORMALCOLOR [UIColor colorWithRed:134.0/255 green:139.0/255 blue:142.0/255 alpha:1.0]
#define TABTITLESELECTCOLOR [UIColor colorWithRed:14.0/255 green:118.0/255 blue:168.0/255 alpha:1.0]

@interface SYMTabController ()

@end

@implementation SYMTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(UITabBarController *)createTabViewController
{
    NSArray *controllersArr = @[SYMHomeController,SYMFinancialSupermarketController,SYMMyAssetsController, SYMPersonalController];
    NSArray *imageArr = @[SYMHomeImage,SYMFinancialSupermarketImage,SYMMyAssetsImage,SYMPersonalCenterImage];
    NSArray *imageSelectArr = @[SYMHomeImageSelect,SYMFinancialSupermarketImageSelect,SYMMyAssetsImageSelect,SYMPersonalCenterImageSelect];
    NSArray *titleArr = @[SYMHomeTitle,SYMFinancialSupermarketTitle,SYMMyAssetsTitle,SYMPersonalCenterTitle];
    
    NSMutableArray *navArr = [[NSMutableArray alloc]init];
    for (int i=0; i<[controllersArr count]; i++) {
        NSString *vcStr = [NSString stringWithFormat:@"%@ViewController",controllersArr[i]];
        Class controllerClass = NSClassFromString(vcStr);
        UIViewController *controller = [[controllerClass alloc]init];
        SYMNavViewController *nav = [[SYMNavViewController alloc]initWithRootViewController:controller];
        nav.tabBarItem.title = titleArr[i];
        nav.tabBarItem.image = [UIImage imageNamed:imageArr[i]];
        nav.tabBarItem.selectedImage = [UIImage imageNamed:imageSelectArr[i]];
        [navArr addObject:nav];
    }
    SYMTabController *btTab = [[SYMTabController alloc]init];
    btTab.titleArray = titleArr;
    btTab.tabbarImageNormal = imageArr;
    btTab.tabbarImageSelect = imageSelectArr;
    [btTab setViewControllers:navArr];
    return btTab;
}

+(void)updateViewControllers:(UITabBarController *)mytabBarController
{
    
    //    NSMutableArray *currentControllers = [NSMutableArray arrayWithArray:mytabBarController. viewControllers];
    //    SYMNavViewController *myNav = [[SYMNavViewController alloc] initWithRootViewController:[[BtmAcceptViewController alloc]init]];
    //    myNav.tabBarItem.title = BTMGatherTitle;
    //    myNav.tabBarItem.image = [UIImage imageNamed:BTMGatherImage];
    //    myNav.tabBarItem.selectedImage = [UIImage imageNamed:BTMGatherImageSelect];
    //    [currentControllers replaceObjectAtIndex:1 withObject:myNav];
    //    [mytabBarController setViewControllers:currentControllers];
}

+(void)enableControllers:(UITabBarController *)myTabBarController Number:(NSArray *)numbers enable:(BOOL)enable
{
    if (enable) {
        for (NSString *number in numbers) {
            
            SYMTabBarItem *myItem = (SYMTabBarItem *)[[(SYMTabController *)myTabBarController myTabBar] viewWithTag:[number integerValue]+TABBARTAG];
            myItem.userInteractionEnabled = YES;
            [myItem.tabBarImage setAlpha:1];
            [myItem.tabBarTitle setAlpha:1];
        }
    }
    else {
        for (NSString *number in numbers) {
            
            SYMTabBarItem *myItem = (SYMTabBarItem *)[[(SYMTabController *)myTabBarController myTabBar] viewWithTag:[number integerValue]+TABBARTAG];
            myItem.userInteractionEnabled = NO;
            [myItem.tabBarImage setAlpha:0.4];
            [myItem.tabBarTitle setAlpha:0.4];
        }
    }
}


-(void)noticeWithViewControllerNumber:(NSInteger)vcNum
{
    SYMTabBarItem *myItem = (SYMTabBarItem *)[self.view viewWithTag:vcNum+TABBARTAG];
    myItem.tabBarTipsImage.hidden = NO;
}

-(void)noticeCancelWithViewControllerNumber:(NSInteger)vcNum
{
    SYMTabBarItem *myItem = (SYMTabBarItem *)[self.view viewWithTag:vcNum+TABBARTAG];
    myItem.tabBarTipsImage.hidden = YES;
}

-(void)hidenTabBar:(BOOL)isHiden
{
    [self.tabBar setHidden:isHiden];
    [self.myTabBar setHidden:isHiden];
}

-(void)setCurrentSelectIndex:(NSInteger)selectedIndex
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = TABBARTAG+selectedIndex;
    [self btnClick:btn];
}

-(void)btnClick:(UIButton *)btn
{
    for (int i=0; i<_titleArray.count; i++) {
        SYMTabBarItem *myItem = (SYMTabBarItem *)[self.view viewWithTag:i+TABBARTAG];
        if (btn.tag == (i+TABBARTAG)) {
            myItem.tabBarImage.image = [UIImage imageNamed:_tabbarImageSelect[i]];
            myItem.tabBarTitle.textColor = TABTITLESELECTCOLOR;
            myItem.tabBarTipsImage.hidden = YES;
        }
        else{
            myItem.tabBarImage.image = [UIImage imageNamed:_tabbarImageNormal[i]];
            myItem.tabBarTitle.textColor = TABTITLENORMALCOLOR;
        }
    }
    self.selectedIndex = btn.tag - TABBARTAG;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    static int flag = 0;
    if (flag == 0) {
        self.myTabBar = [[UITabBar alloc]init];
        self.myTabBar.frame = self.tabBar.frame;
        UIView *bgView = [[UIView alloc] initWithFrame:self.myTabBar.bounds];
        //        bgView.backgroundColor = [UIColor colorWithHexString:@"#f5f9fd" alpha:0.4];//#dddddd SYMTabBarColor
        bgView.backgroundColor =SYMTabBarColor;
        [self.myTabBar insertSubview:bgView atIndex:0];
        self.tabBar.opaque = YES;
        
        for (int i=0; i<_titleArray.count; i++) {
            CGFloat width = self.tabBar.frame.size.width/_titleArray.count;
            CGFloat height = self.tabBar.frame.size.height;
            CGFloat x = i*width;
            CGFloat y = 0;
            SYMTabBarItem *myItem = [[[NSBundle mainBundle] loadNibNamed:@"SYMTabBarItem" owner:self options:nil]lastObject];
            if (BTMHeight== 736.000000) {
                
                myItem.tabBarImage.translatesAutoresizingMaskIntoConstraints = NO;
                [myItem addConstraint:[NSLayoutConstraint constraintWithItem:myItem.tabBarImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:myItem attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
                [myItem addConstraint:[NSLayoutConstraint constraintWithItem:myItem.tabBarImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:myItem attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                
                myItem.tabBarTipsImage.translatesAutoresizingMaskIntoConstraints = NO;
                [myItem addConstraint:[NSLayoutConstraint constraintWithItem:myItem.tabBarTipsImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:myItem attribute:NSLayoutAttributeTop multiplier:1 constant:6]];
            }
            [myItem setFrame:CGRectMake(x, y, width, height)];
            myItem.tabBarImage.image = [UIImage imageNamed:_tabbarImageNormal[i]];
            myItem.tabBarTitle.text = _titleArray[i];
            myItem.tabBarTipsImage.hidden = YES;
            myItem.tag = TABBARTAG+i;
            myItem.bgButton.tag = TABBARTAG+i;
            [myItem.bgButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                [self btnClick:myItem.bgButton];
            }
            myItem.backgroundColor =SYMTabBarColor;
            //[UIColor clearColor];
            [self.myTabBar addSubview:myItem];
        }
        [self.view addSubview:self.myTabBar];
        SYMTabBarItem *myItem = (SYMTabBarItem *)[self.view viewWithTag:TABBARTAG];
        [self btnClick:myItem.bgButton];
        flag ++;
    }
}

@end

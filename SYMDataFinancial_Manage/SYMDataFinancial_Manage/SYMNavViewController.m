//
//  SYMNavViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "SYMNavViewController.h"
#import "SYMConstantCenter.h"

@interface SYMNavViewController ()

@end

@implementation SYMNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self.navigationBar setBackgroundColor:BTMBLUECOLOR];//
//    [self.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_titlebar"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Arial-Bold" size:0.0], NSFontAttributeName, nil]];
    
    [self.navigationBar setTranslucent:NO];//设置navigationbar的半透明
    [self.navigationBar setBarTintColor:SYMBLUECOLOR];
    if (iOS7) {
        [self.navigationBar setTintColor:SYMBLUECOLOR];
    }
    
    /**
     *  去掉导航栏的分割线
     */
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

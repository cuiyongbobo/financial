//
//  MainViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "MainViewController.h"
#import "SYMConstantCenter.h"
#import "SYMDataBaseCenter.h"
#import "GestureViewController.h"
#import "SYMDataBaseModel.h"
#import "PCCircleViewConst.h"
#import "ZplayNoject.h"
#import "BtmMobile.h"

@interface MainViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    UIButton *rightButton;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=SYMBDClolor;
    //添加手势 用于回收键盘
    //    _myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
    //    [self.view addGestureRecognizer:_myTap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notices:) name:EnterApplication object:nil];
    [[BtmMobile shareBtmMoile]stopMove];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EnterApplication object:nil];
}

#pragma mark- 注册进入app通知
-(void)notices:(NSNotification *)notify
{
    NSLog(@"进入应用");
    NSArray *array=[[SYMDataBaseCenter defaultDatabase]getAllinformationByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    if (array.count!=0) {
        for (UserInformation *userinformation in array) {
            // 给手势密码赋值
            [[NSUserDefaults standardUserDefaults]setObject:userinformation.gesturespassword forKey:gestureFinalSaveKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            [gestureVc setType:GestureViewControllerTypeLogin];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:LoginPage];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController pushViewController:gestureVc animated:NO];
        }
    }
    
}

#pragma mark- 判断有无网络环境
-(BOOL)isMainhaveNetwork
{
    if ([[ZplayNoject shareInstance]isHaveConnect]) {
        return YES;
    }else{
        // 没有网
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        return NO;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
#if 0
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
#endif
    
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

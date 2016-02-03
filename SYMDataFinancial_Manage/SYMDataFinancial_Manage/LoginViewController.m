//
//  LoginViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "LoginViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "RegisteredViewController.h"
#import "SYMBackPasswordViewController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseCenter.h"
#import "MyTipsWindow.h"
#import "PCCircleViewConst.h"
#import "ZplayNoject.h"
#import "BtmMobile.h"

@interface LoginViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    
    UITapGestureRecognizer *_myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
    [self.view addGestureRecognizer:_myTap];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"登录";
    
    //  定义Navigation 的左右按钮
    UIButton *Leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    Leftbutton.frame=CGRectMake(0, 0, 23/2*SYMWIDthRATESCALE, 41/2*SYMHEIGHTRATESCALE);
    Leftbutton.tag=300;
    [Leftbutton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [Leftbutton addTarget:self action:@selector(LeftandRightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft=[[UIBarButtonItem alloc]initWithCustomView:Leftbutton];
    self.navigationItem.leftBarButtonItem=itemLeft;
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:SYMFontColor];
    [_TitleImage addSubview:companyAccount];
}

-(void)LeftandRightClick:(UIButton *)button{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        SYMTabController *myTab = (SYMTabController *)self.tabBarController;
        [myTab setCurrentSelectIndex:0];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.BDScrollView.frame.size.height-(self.LoginButton.frame.origin.y+self.LoginButton.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.BDScrollView.frame.size.height-(self.LoginButton.frame.origin.y+self.LoginButton.frame.size.height));
        [UIView animateWithDuration:0.3f animations:^{
            self.BDScrollView.contentOffset = CGPointMake(0,Lowhight+10);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

static bool isClick=YES;
-(IBAction)btnClick:(id)sender{
    UIButton *button=(UIButton *)sender;
    if (button.tag==403) {
        RegisteredViewController *registvc=[[RegisteredViewController alloc]initWithNibName:@"RegisteredViewController" bundle:nil];
        [self.navigationController pushViewController:registvc animated:YES];
    }else if (button.tag==404){
        SYMBackPasswordViewController *back=[[SYMBackPasswordViewController alloc]initWithNibName:@"SYMBackPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:back animated:YES];
    }else if (button.tag==402){
        if (![[SYMPublicDictionary shareDictionary]judgeString:self.IPhoneNumber.text]) {
            if ([self isMobileNumber:self.IPhoneNumber.text]) {
                if (![[SYMPublicDictionary shareDictionary]judgeString:self.Password.text]) {
                    [self UserLogin];
                }else{
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入密码" backgroundcolor:white];
                }
                
            }else{
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入有效的手机号" backgroundcolor:white];
            }
        }else{
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入手机号" backgroundcolor:white];
        }
    }else if (button.tag==401){
        if (isClick) {
            isClick=NO;
            self.Password.secureTextEntry = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima.png"] forState:UIControlStateNormal];
        }else{
            isClick=YES;
            self.Password.secureTextEntry = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"zhuce_biyan"] forState:UIControlStateNormal];
        }
    }
}

-(void)tapBack:(UITapGestureRecognizer *) tap{
    [UIView animateWithDuration:0.3f animations:^{
        [self.IPhoneNumber resignFirstResponder];
        [self.Password resignFirstResponder];
        self.BDScrollView.contentOffset=CGPointMake(0, 0);
        //self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

#pragma mark -登录接口
-(void)UserLogin
{
    [[BtmMobile shareBtmMoile]startMove:self];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]UserLoginPublicDictnary:self.IPhoneNumber.text loginPwd:self.Password.text];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMUserLogin_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dict=responsedict[@"data"];
            if (![[NSString stringWithFormat:@"%@",dict[@"isReal"]] isEqualToString:@"0"]) {
                // 设置过支付密码
                [[NSUserDefaults standardUserDefaults] setObject:@"设置过" forKey:SETPasswordStatus];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            // 将UserType存入数据库
            //[[SYMDataBaseCenter defaultDatabase]addRecordWithObject:@""];
            // 登录成功
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"登录成功" backgroundcolor:white];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"userId"] forKey:ISLogIN];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",dict[@"userType"]] forKey:UserType];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"isDistribute"] forKey:ISdistribution];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:self.Password.text forKey:UserPassword];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:ForgetPassword]) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:gestureFinalSaveKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:ForgetPassword];
                [[NSUserDefaults standardUserDefaults]synchronize];
                SYMTabController *myTab = (SYMTabController *)self.tabBarController;
                [myTab setCurrentSelectIndex:0];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                if (self.backLogin) {
                    [[NSUserDefaults standardUserDefaults]setObject:self.IPhoneNumber.text forKey:IPhonenumber];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    self.backLogin();
                }
            });
            [[BtmMobile shareBtmMoile]stopMove];
        }else{
            [[BtmMobile shareBtmMoile]stopMove];
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:responsedict[@"message"] backgroundcolor:white];
        }
    } failure:^(NSError *error){
        
        NSLog(@"error-->%@",error);
        [[BtmMobile shareBtmMoile]stopMove];
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }];
}

#pragma mark- 判断手机号
//以上集合一起，并兼容14开头的
-(BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:mobileNum]) {
        return YES;
    }else{
        return NO;
    }
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

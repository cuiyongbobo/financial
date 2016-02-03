//
//  LoginViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMSetpasswordViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "RegisteredViewController.h"
#import "SYMBackPasswordViewController.h"

@interface SYMSetpasswordViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation SYMSetpasswordViewController

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
    companyAccount.text=@"设置支付密码";
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
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
        
        //NSLog(@"屏幕高度--->%f",hight);
        [UIView animateWithDuration:0.3f animations:^{
            
            self.BDScrollView.contentOffset = CGPointMake(0,Lowhight+10);
        }];
    }
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //    //isflags=NO;
    //    dispatch_queue_t queue=dispatch_get_main_queue();
    //    dispatch_async(queue, ^{
    //
    //        if (_EmailTextField.text.length==0 || _PassWordTextField.text.length==0) {
    //
    //            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:NSLocalizedString(@"UserErrorNULL", nil) backgroundcolor:black];  // 背景为白色的提示框的颜色为黑色的
    //        }
    //
    //    });
    //
    //    [UIView  animateWithDuration:0.3f animations:^{
    //
    //        self.BTMScrollview.contentOffset = CGPointMake(0,0);
    //
    //    }];
    
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
    }else if (button.tag==401)
    {
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

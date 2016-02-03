//
//  LoginViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMBackpayPasswordViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "MyTipsWindow.h"

@interface SYMBackpayPasswordViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    BOOL _isTime;
    int timecount;
    NSTimer *_timer;
    NSString *_VerificationCode;
}
@end

@implementation SYMBackpayPasswordViewController

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
    companyAccount.text=@"找回支付密码";
    
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
    int height = keyboardRect.size.height+80;
    if (self.BDScrollView.frame.size.height-(self.NewInformationTextField.frame.origin.y+self.NewInformationTextField.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.BDScrollView.frame.size.height-(self.NewInformationTextField.frame.origin.y+self.LoginButton.frame.size.height));
        [UIView animateWithDuration:0.3f animations:^{
            self.BDScrollView.contentOffset = CGPointMake(0,Lowhight);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

-(void)tapBack:(UITapGestureRecognizer *) tap{
    [UIView animateWithDuration:0.3f animations:^{
        [self.IPhoneNumber resignFirstResponder];
        [self.Password resignFirstResponder];
        //[self.NewPasswordTextField resignFirstResponder];
        //[self.InformationTextField resignFirstResponder];
        self.BDScrollView.contentOffset=CGPointMake(0, 0);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

-(void)timerFired
{
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",timecount--] forState:0];
    if (timecount==1||timecount<1) {
        [_timer invalidate];
        _timer=nil;
        [self.codeBtn setTitle:@"获取验证码" forState:0];
        [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"btn_huoquyanzhengma"] forState:UIControlStateNormal];
    }
}

-(void)time
{
    self.codeBtn.userInteractionEnabled = YES;
}
- (void)endTime
{
    _isTime = NO;
}

static bool isClick=YES;
-(IBAction)btnClick:(id)sender{
    
    UIButton *button=(UIButton *)sender;
    if (button.tag==401) {
        
        [self getPhoneNumber];
        
        [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"icon_yanzhengma_jishi"] forState:UIControlStateNormal];
        timecount = 60;
        _isTime = YES;
        [NSTimer scheduledTimerWithTimeInterval:5*60.0 target:self selector:@selector(endTime) userInfo:nil repeats:NO];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(time) userInfo:nil repeats:NO];
        self.codeBtn.userInteractionEnabled = NO;
    }else if (button.tag==402){
        // 验证验证码和所填写的是否一致
        if ([self.Password.text isEqualToString:[NSString stringWithFormat:@"%@",_VerificationCode]]) {
            NSLog(@"验证码相同");
            [self setPayPass];
            
        }else{
            NSLog(@"验证码填写不一致");
        }
        
    }else if (button.tag==403)
    {
        if (isClick) {
            isClick=NO;
            self.NewInformationTextField.secureTextEntry = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima.png"] forState:UIControlStateNormal];
        }else{
            isClick=YES;
            self.NewInformationTextField.secureTextEntry = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"zhuce_biyan"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark- 获取验证码
-(void)getPhoneNumber
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]getIPhoneNumberPublicDictnary:self.IPhoneNumber.text];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMGetIphoneNumber_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"getPhoneNumberresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dict=responsedict[@"data"];
            _VerificationCode=dict[@"checkNo"];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        return ;
    }];
}

#pragma mark- 设置支付密码接口
-(void)setPayPass
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]SetPayPasswordPublicDictnary:[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN] pwdType:1 mobile:@"" loginPwd:@"" cashPwd:self.NewInformationTextField.text];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMSetPayPassWord_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            // 设置成功
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"支付密码找回成功" backgroundcolor:white];
            NSLog(@"message=%@",responsedict[@"message"]);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:responsedict[@"message"] backgroundcolor:white];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
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

//
//  LoginViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "RegisteredViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "SYMConstantCenter.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "BtmSharePinPassWordViewController.h"
#import "SYMPhoneInformation.h"
#import "MyTipsWindow.h"
#import "SYMServiceAgreementViewController.h"
#import "ZplayNoject.h"
#import "BtmMobile.h"

@interface RegisteredViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    BOOL _isTime;
    int timecount;
    NSTimer *_timer;
}
@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    
    UITapGestureRecognizer *_myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
    [self.view addGestureRecognizer:_myTap];
    [self.PassWordButton pointInside:CGPointMake(300, 300) withEvent:nil];
    
    UITapGestureRecognizer *_myTapMore = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackMore:)];
    self.LinkLabel.userInteractionEnabled=YES;
    [self.LinkLabel addGestureRecognizer:_myTapMore];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"注册";
    
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
{    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height+80;
    if (self.BDScrollView.frame.size.height-(self.InformationTextField.frame.origin.y+self.InformationTextField.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.BDScrollView.frame.size.height-(self.InformationTextField.frame.origin.y+self.InformationTextField.frame.size.height));
        //NSLog(@"屏幕高度--->%f",hight);
        [UIView animateWithDuration:0.3f animations:^{
            self.BDScrollView.contentOffset = CGPointMake(0,Lowhight);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

-(void)timerFired
{
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds",timecount--] forState:0];
    if (timecount==1||timecount<1) {
        [_timer invalidate];
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
static bool isREClick=YES;
-(IBAction)btnClick:(id)sender{
    
    UIButton *button=(UIButton *)sender;
    if (button.tag==401) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            if ([[SYMPublicDictionary shareDictionary]judgeString:self.IPhoneNumber.text]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入手机号" backgroundcolor:white];
                });
            }else{
                BOOL isb=[self isMobileNumber:self.IPhoneNumber.text];
                if (isb) {
                    [self detectionIphoneNumber];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入有效的手机号" backgroundcolor:white];
                    });
                }
            }
            
        });
    }else if (button.tag==403){
        if (isClick) {
            isClick=NO;
            self.NewPasswordTextField.secureTextEntry = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima.png"] forState:UIControlStateNormal];
        }else{
            isClick=YES;
            self.NewPasswordTextField.secureTextEntry = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"zhuce_biyan"] forState:UIControlStateNormal];
        }
    }else if (button.tag==404){
        if (isREClick) {
            isREClick=NO;
            [button setBackgroundImage:[UIImage imageNamed:@"shape-over.png"] forState:UIControlStateNormal];
            self.LoginButton.enabled=NO;
        }else{
            isREClick=YES;
            [button setBackgroundImage:[UIImage imageNamed:@"shape.png"] forState:UIControlStateNormal];
            self.LoginButton.enabled=YES;
        }
    }else if (button.tag==405){
        
        // 邀请码
        BtmSharePinPassWordViewController *btmSPVc = [[BtmSharePinPassWordViewController alloc] init];
        btmSPVc.isinput=isInviteCode;
        [btmSPVc defaultStandPinPassword:self];
        btmSPVc.backPassword = ^(NSString *password)
        {
            
        };
        [self presentViewController:btmSPVc animated:NO completion:nil];
    }else if (button.tag==402){
        // 注册接口
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([[SYMPublicDictionary shareDictionary]judgeString:self.IPhoneNumber.text]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入手机号" backgroundcolor:white];
                });
            }else{
                BOOL isb=[self isMobileNumber:self.IPhoneNumber.text];
                if (isb) {
                    if ([[SYMPublicDictionary shareDictionary]judgeString:self.Password.text]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入验证码" backgroundcolor:white];
                        });
                    }else{
                        BOOL isc=[self isPassword:self.NewPasswordTextField.text];
                        if (isc) {
                            if (![[SYMPublicDictionary shareDictionary]judgeString:self.NewPasswordTextField.text]) {
                                
                                if (![[SYMPublicDictionary shareDictionary]judgeString:self.InformationTextField.text]) {
                                    if (self.InformationTextField.text.length==8) {
                                        [self requestRegister];
                                    }else{
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"邀请码为8位数字" backgroundcolor:white];
                                        });
                                    }
                                    
                                }else{
                                    [self requestRegister];
                                }
                            }
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"密码为6-20位数字和字母组合" backgroundcolor:white];
                            });
                        }
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入有效的手机号" backgroundcolor:white];
                    });
                }
            }
            
            //            if ([[SYMPublicDictionary shareDictionary]judgeString:self.IPhoneNumber.text]) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入手机号" backgroundcolor:white];
            //                });
            //            }else{
            //
            //            }
            
        });
    }
}

-(void)tapBack:(UITapGestureRecognizer *) tap{
    [UIView animateWithDuration:0.3f animations:^{
        [self.IPhoneNumber resignFirstResponder];
        [self.Password resignFirstResponder];
        [self.NewPasswordTextField resignFirstResponder];
        [self.InformationTextField resignFirstResponder];
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

#pragma mark- 检测手机号是否存在
-(void)detectionIphoneNumber{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]detectionIPhoneNumberPublicDictnary:self.IPhoneNumber.text];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMDetectionIphoneNumber_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"detectionIphoneNumberresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            if ([[NSString stringWithFormat:@"%@",responsedict[@"data"]] isEqualToString:@"1"]) {
                // 手机号存在
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"手机号存在"] backgroundcolor:white];
                NSLog(@"手机号存在");
                
            }else{
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"验证码已发送"] backgroundcolor:white];
                // 手机号不存在
                [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"icon_yanzhengma_jishi"] forState:UIControlStateNormal];
                timecount = 120;
                _isTime = YES;
                [NSTimer scheduledTimerWithTimeInterval:5*120.0 target:self selector:@selector(endTime) userInfo:nil repeats:NO];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(time) userInfo:nil repeats:NO];
                self.codeBtn.userInteractionEnabled = NO;
                [self getPhoneNumber];
            }
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        return ;
    }];
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
            
        }else{
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"%@",responsedict[@"message"]] backgroundcolor:white];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        return ;
    }];
}

#pragma mark- 链接
-(void)tapBackMore:(UITapGestureRecognizer *) tap{
    NSLog(@"跳转链接");
    SYMServiceAgreementViewController *agreement=[[SYMServiceAgreementViewController alloc]initWithNibName:@"SYMServiceAgreementViewController" bundle:nil];
    agreement.weburl=@"http://123.57.248.253/webapp/more?resource=service_agreement&terminal=2";
    [self.navigationController pushViewController:agreement animated:YES];
}

#pragma mark- 注册接口
-(void)requestRegister{
    [[BtmMobile shareBtmMoile]startMove:self];
    NSDictionary *inforMationdict=[[SYMPhoneInformation sharePhoneInformation]getinfo];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]joinPublicDictnary:self.IPhoneNumber.text loginPwd:self.NewPasswordTextField.text checkNo:self.Password.text mac:inforMationdict[@"macaddress"] source:0 appVersion:inforMationdict[@"versionnum"] terminal:@"2" imei:inforMationdict[@"idfa"] brand:inforMationdict[@"devicename"] telModel:inforMationdict[@"phonemodel"] plmn:inforMationdict[@"plmn"] inviteCode:@"" invitationCode:@"" invitationUrl:@""];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMUserRegistration_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegisterresponseObj-->%@",responsedict);
        [[BtmMobile shareBtmMoile]stopMove];
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSMutableDictionary *dict=responsedict[@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"userId"] forKey:ISLogIN];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",dict[@"userType"]] forKey:UserType];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"isDistribute"] forKey:ISdistribution];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:self.Password.text forKey:UserPassword];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:self.IPhoneNumber.text forKey:IPhonenumber];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:RegisteredSuccess object:self userInfo:nil];
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"注册成功" backgroundcolor:white];
            SYMTabController *myTab = (SYMTabController *)self.tabBarController;
            [myTab setCurrentSelectIndex:0];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [[BtmMobile shareBtmMoile]stopMove];
            NSLog(@"message=%@",responsedict[@"message"]);
            if ([[NSString stringWithFormat:@"%@",responsedict[@"message"]] isEqualToString:@"2009"]) {
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"验证码已超时,请重新获取" backgroundcolor:white];
            }else if ([[NSString stringWithFormat:@"%@",responsedict[@"message"]] isEqualToString:@"2008"])
            {
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请重新输入正确的验证码" backgroundcolor:white];
            }else{
                
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:responsedict[@"message"] backgroundcolor:white];
            }
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

#pragma mark- 判断密码
-(BOOL)isPassword:(NSString *)password
{
    NSString * phoneRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if ([regextestmobile evaluateWithObject:password]) {
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

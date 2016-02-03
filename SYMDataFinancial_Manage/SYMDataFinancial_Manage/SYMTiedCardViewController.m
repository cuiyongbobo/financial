//
//  SYMTiedCardViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/24.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMTiedCardViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "SYMSupportBankViewController.h"
#import "BtmSharePinPassWordViewController.h"
#import "SYMSetPaypasswordViewController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMSecurityWebViewController.h"
#import "SYMInformationSave.h"
#import "SYMBackpayPasswordViewController.h"
#import "MyTipsWindow.h"

@interface SYMTiedCardViewController ()<UITextFieldDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSString *_bankCodes;
}
@end

@implementation SYMTiedCardViewController

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
    companyAccount.text=@"绑定银行卡";
    
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

static bool isREClick=YES;
-(IBAction)btnClick:(id)sender{
    
    UIButton *button=(UIButton *)sender;
    if (button.tag==200) {
        // 选择阅读
        if (isREClick) {
            isREClick=NO;
            [button setBackgroundImage:[UIImage imageNamed:@"shape-over.png"] forState:UIControlStateNormal];
            self.NextButton.enabled=NO;
        }else{
            isREClick=YES;
            [button setBackgroundImage:[UIImage imageNamed:@"shape.png"] forState:UIControlStateNormal];
            self.NextButton.enabled=YES;
        }
    }else if (button.tag==201){
        [self loadInputParm];
        NSLog(@"isreal=%@",self.acconutmodel.isReal);
        // 判断购买金额
        [self isNotnil];
    }else if (button.tag==202){
        // 选择银行卡
        SYMSupportBankViewController *Bank=[[SYMSupportBankViewController alloc]initWithNibName:@"SYMSupportBankViewController" bundle:nil];
        Bank.distributorCode=self.acconutmodel.distributorCode;
        [self.navigationController pushViewController:Bank animated:YES];
    }
}

#pragma mark- Textfiled
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
    if (self.BDScrollView.frame.size.height-(self.CardNumberTextField.frame.origin.y+self.CardNumberTextField.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.BDScrollView.frame.size.height-(self.CardNumberTextField.frame.origin.y+self.CardNumberTextField.frame.size.height));
        NSLog(@"屏幕高度--->%f",Lowhight);
        [UIView animateWithDuration:0.3f animations:^{
            self.BDScrollView.contentOffset=CGPointMake(0, Lowhight+20);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getnotiFly:) name:ReturnData object:nil];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    [self registerForKeyboardNotifications];
    if ([[SYMPublicDictionary shareDictionary]judgeString:_bankCodes]) {
        [self loadinitData];
    }
}

#pragma mark- 通知方法
-(void)getnotiFly:(NSNotification *)notify
{
    NSLog(@"dict=%@",notify);
    NSLog(@"notify--key%@",notify.userInfo[@"key"]);
    NSString *bankName=notify.userInfo[@"key"];
    _bankCodes=notify.userInfo[@"bankCode"];
    self.CardNameLabel.text=bankName;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:ReturnData object:nil];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

-(void)tapBack:(UITapGestureRecognizer *) tap{
    [UIView animateWithDuration:0.3f animations:^{
        [self.IdNumberTextField resignFirstResponder];
        [self.CardNumberTextField resignFirstResponder];
        [self.NameTextField resignFirstResponder];
        [self.AmountLabel resignFirstResponder];
        self.BDScrollView.contentOffset=CGPointMake(0, 0);
    }];
}

#pragma mark- 加载初始化数据
-(void)loadinitData
{
    self.AmountLabel.text=self.InvestmentAmount;
    self.NameTextField.text=[NSString stringWithFormat:@"%@",self.acconutmodel.investorName];
    self.IdNumberTextField.text=[NSString stringWithFormat:@"%@",self.acconutmodel.idCardNo];
    self.CardNumberTextField.text=[NSString stringWithFormat:@"%@",self.acconutmodel.cardNo];
    if (![[SYMPublicDictionary shareDictionary]judgeString:[NSString stringWithFormat:@"%@",self.acconutmodel.investorName]]){
        self.NameTextField.enabled=NO;
        [self.NameTextField setTextColor:[UIColor grayColor]];
    }
    
    if (![[SYMPublicDictionary shareDictionary]judgeString:[NSString stringWithFormat:@"%@",self.acconutmodel.idCardNo]]){
        self.IdNumberTextField.enabled=NO;
        [self.IdNumberTextField setTextColor:[UIColor grayColor]];
    }
    if (![[SYMPublicDictionary shareDictionary]judgeString:[NSString stringWithFormat:@"%@",self.acconutmodel.bankName]]){
        self.CardNameLabel.text=[NSString stringWithFormat:@"%@",self.acconutmodel.bankName];
    }
}

#pragma mark- 加载传入参数
-(void)loadInputParm
{
    _customerModel=[[CustomerInformation alloc]init];
    _customerModel.payamount=self.AmountLabel.text;
    _customerModel.username=self.NameTextField.text;
    _customerModel.idCard=self.IdNumberTextField.text;
    _customerModel.bankcarName=self.CardNameLabel.text;
    _customerModel.bankCarNo=self.CardNumberTextField.text;
    if (_bankCodes.length!=0) { // 反选不为空
        _customerModel.bankCode=_bankCodes;
    }else{
        _customerModel.bankCode=self.acconutmodel.bankCode;
    }
    NSLog(@"_customerModel=%@",_customerModel.bankCode);
}

#pragma mark- 购买接口
-(void)BuyTheProduct
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    ProductDetails *modeldetail=[SYMInformationSave defaultSaveInformation].detailModel;
    paramDict=[[SYMPublicDictionary shareDictionary]PayProductPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] distributorCode:self.acconutmodel.distributorCode isIndividual:@"0" productCode:modeldetail.productCode amount:self.customerModel.payamount investorName:self.customerModel.username certType:@"0" idCardNo:self.customerModel.idCard bankCode:self.customerModel.bankCode bankName:self.customerModel.bankcarName cardNo:self.customerModel.bankCarNo mobilePhone:self.acconutmodel.mobilePhone buyMode:self.acconutmodel.buyMode custNo:self.acconutmodel.custNo isInvestAgain:[SYMInformationSave defaultSaveInformation].isstate payMode:self.acconutmodel.payMode invitecode:@"" reserve1:@"1" reserve2:@"1" reserve3:@"" reserve4:@"1" reserve5:@"" orderNo:@""];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMBuyProduct_URL params:paramDict success:^(id responseObj){
        
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responsedict=%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            
            if (![[SYMPublicDictionary shareDictionary]judgeString:responsedict[@"data"]]) {
                NSDictionary *dict=responsedict[@"data"];
                Buyproduct *buymodel=[[Buyproduct alloc]init];
                buymodel.url=dict[@"url"];
                buymodel.pageMode=dict[@"pageMode"];
                buymodel.req_data=dict[@"req_data"];
                
                SYMSecurityWebViewController *webview=[[SYMSecurityWebViewController alloc]initWithNibName:@"SYMSecurityWebViewController" bundle:nil];
                webview.model=buymodel;
                [self.navigationController pushViewController:webview animated:YES];
            }
        }else{
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:responsedict[@"message"] backgroundcolor:white];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 输入内容判断
-(void)inputInformation
{
    // BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:self.AmountLabel.text];
    // if (!b) {
    
    NSString *minInvest=_detailModel.minInvest;
    NSString *maxInvest=_detailModel.maxInvest;
    NSString *raiseInvest=_detailModel.raiseInvest;
    NSString *remaining=_detailModel.remaining;
    if ([self.AmountLabel.text intValue]<[minInvest intValue]) {
        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"买入金额不能小于%@",minInvest] backgroundcolor:white];
    }else{
        NSLog(@"--->%d",[self.AmountLabel.text intValue]%[raiseInvest intValue]);
        if (!([self.AmountLabel.text intValue]%[raiseInvest intValue]==0)) {
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"买入金额必须为%@的整数倍",raiseInvest] backgroundcolor:white];
        }else{
            // 正常的
            if ([remaining intValue]<=[maxInvest intValue]) {
                if ([self.AmountLabel.text intValue]<[remaining intValue]) {
                    // 正常
                    [self loadbusiness];
                }else{
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"不能大于%@",remaining] backgroundcolor:white];
                }
                
            }else{
                if ([self.AmountLabel.text intValue]<[maxInvest intValue]) {
                    // 正常
                    [self loadbusiness];
                }else{
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"不能大于%@",maxInvest] backgroundcolor:white];
                }
            }
        }
    }
    
    //    }else{
    //        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入购买金额" backgroundcolor:white];
    //        NSLog(@"请输入购买金额");
    //    }
}

#pragma mark- 业务逻辑
-(void)loadbusiness
{
    if (![[NSString stringWithFormat:@"%@",self.acconutmodel.isReal] isEqualToString:@"0"]) { //!
        [[NSUserDefaults standardUserDefaults]setObject:@"ok" forKey:SETPasswordStatus];
        [[NSUserDefaults standardUserDefaults]synchronize];
        // 未实名认证
        BtmSharePinPassWordViewController *PinPasswordVC=[[BtmSharePinPassWordViewController alloc]initWithNibName:@"BtmSharePinPassWordViewController" bundle:nil];
        PinPasswordVC.isinput=isNotReslName;
        PinPasswordVC.sendmoney=self.AmountLabel.text;
        [PinPasswordVC defaultStandPinPassword:self];
        [self presentViewController:PinPasswordVC animated:NO completion:nil];
        PinPasswordVC.backPassword = ^(NSString *password)
        {
            NSLog(@"密码框回调");
            NSLog(@"password=%@",password);
            // 发起购买请求
            [self BuyTheProduct];
        };
        
        PinPasswordVC.forgetpassword=^{
            dispatch_async(dispatch_get_main_queue(), ^{
                SYMBackpayPasswordViewController *backpaypassword=[[SYMBackpayPasswordViewController alloc]initWithNibName:@"SYMBackpayPasswordViewController" bundle:nil];
                [self.navigationController pushViewController:backpaypassword animated:YES];
            });
        };
    }else{
        // 去设置支付密码
        SYMSetPaypasswordViewController *payPassword=[[SYMSetPaypasswordViewController alloc]initWithNibName:@"SYMSetPaypasswordViewController" bundle:nil];
        payPassword.accomodel=self.acconutmodel;
        payPassword.amount=self.AmountLabel.text;
        payPassword.customerModel=_customerModel;
        [self.navigationController pushViewController:payPassword animated:YES];
    }
}

#pragma mark- 判断非空
-(void)isNotnil
{
    if ([[SYMPublicDictionary shareDictionary]judgeString:self.AmountLabel.text]) {
        NSLog(@"请输入购买金额");
        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入购买金额" backgroundcolor:white];
    }else{
        if ([[SYMPublicDictionary shareDictionary]judgeString:self.NameTextField.text]) {
            NSLog(@"请输入姓名");
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入姓名" backgroundcolor:white];
        }else{
            if (self.NameTextField.text.length<=10 &&(![self isPureInt:self.NameTextField.text]&& ![self isPureFloat:self.NameTextField.text])) {
                
                if ([[SYMPublicDictionary shareDictionary]judgeString:self.IdNumberTextField.text]){
                    NSLog(@"请输入身份证号");
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入身份证号" backgroundcolor:white];
                }else{
                    
                    if (![self validateIdentityCard:self.IdNumberTextField.text]) {
                        NSLog(@"输入合法的身份证号");
                        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入合法的身份证号" backgroundcolor:white];
                    }else{
                        if([self.CardNameLabel.text isEqualToString:@"请选择银行卡"]){
                            NSLog(@"请选择银行卡");
                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请选择银行卡" backgroundcolor:white];
                        }else {
                            if ([[SYMPublicDictionary shareDictionary]judgeString:self.CardNumberTextField.text]) {
                                NSLog(@"请输入银行卡卡号");
                                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入银行卡卡号" backgroundcolor:white];
                            }else{
                                // 正常
                                [self inputInformation];
                            }
                        }
                    }
                }
                
            }else{
                NSLog(@"请输入正确的姓名");
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入正确的姓名" backgroundcolor:white];
            }
        }
    }
}

//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark- 判断身份证号
-(BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
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

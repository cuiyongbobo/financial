//
//  LoginViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMSetPaypasswordViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "RegisteredViewController.h"
#import "SYMBackPasswordViewController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMInformationSave.h"
#import "SYMSecurityWebViewController.h"
#import "MyTipsWindow.h"

@interface SYMSetPaypasswordViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation SYMSetPaypasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self.ShowPassbutton pointInside:CGPointMake(300, 300) withEvent:nil];
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
        [UIView animateWithDuration:0.3f animations:^{
            self.BDScrollView.contentOffset = CGPointMake(0,Lowhight);
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
    if (button.tag==401) {
        if (isClick) {
            isClick=NO;
            self.Password.secureTextEntry = NO;
            [button setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima.png"] forState:UIControlStateNormal];
        }else{
            isClick=YES;
            self.Password.secureTextEntry = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"zhuce_biyan"] forState:UIControlStateNormal];
        }
    }else if (button.tag==402){
        if ([[SYMPublicDictionary shareDictionary]judgeString:self.IPhoneNumber.text]) {
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入支付密码" backgroundcolor:white];
        }else if ([[SYMPublicDictionary shareDictionary]judgeString:self.Password.text]){
            
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入确认密码" backgroundcolor:white];
        }else{
            
            if ([self.IPhoneNumber.text isEqualToString:self.Password.text]) {
                
                NSString *backtips= [self isNotNumbercontinu:self.Password.text];
                if (backtips.length==0) {
                    [self setPayPass];
                }else{
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:backtips backgroundcolor:white];
                }
            }else{
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"密码不一致" backgroundcolor:white];
                NSLog(@"密码不一致");
            }
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

#pragma mark- 设置支付密码接口
-(void)setPayPass
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]SetPayPasswordPublicDictnary:[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN] pwdType:1 mobile:@"" loginPwd:@"" cashPwd:self.IPhoneNumber.text];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMSetPayPassWord_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            // 设置支付密码成功
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"设置支付密码成功" backgroundcolor:white];
            [[NSUserDefaults standardUserDefaults]setValue:@"成功" forKey:SETPasswordStatus];
            [[NSUserDefaults standardUserDefaults]synchronize];
            // 调用购买接口
            [self BuyTheProduct];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 购买接口
-(void)BuyTheProduct
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    ProductDetails *modeldetail=[SYMInformationSave defaultSaveInformation].detailModel;
    paramDict=[[SYMPublicDictionary shareDictionary]PayProductPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] distributorCode:self.accomodel.distributorCode isIndividual:@"0" productCode:modeldetail.productCode amount:self.customerModel.payamount investorName:self.customerModel.username certType:@"0" idCardNo:self.customerModel.idCard bankCode:self.customerModel.bankCode bankName:self.customerModel.bankcarName cardNo:self.customerModel.bankCarNo mobilePhone:self.accomodel.mobilePhone buyMode:self.accomodel.buyMode custNo:self.accomodel.custNo isInvestAgain:[SYMInformationSave defaultSaveInformation].isstate payMode:self.accomodel.payMode invitecode:@"" reserve1:@"1" reserve2:@"1" reserve3:@"" reserve4:@"1" reserve5:@"" orderNo:@""];
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
        
//        NSLog(@"SYMSetPayPassWord_URL=%@",SYMBuyProduct_URL);
//        NSString * myGet=[[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];//接收数据
//        NSLog(@"myGet=%@",myGet);
//        SYMSecurityWebViewController *webview=[[SYMSecurityWebViewController alloc]initWithNibName:@"SYMSecurityWebViewController" bundle:nil];
//        webview.weburl=myGet;
//        [self.navigationController pushViewController:webview animated:YES];
        
        
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark- 判断6位不连续数字
-(NSString *)isNotNumbercontinu:(NSString *)numberPass
{
    NSString *backnumber=[[NSString alloc]init];
    
    NSString * phoneRegextwo = @"^(\\d)\\1+$";  // 6位一样的数字
    NSPredicate *regextestmobiletwo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegextwo];
    if (numberPass.length==6) {
        if ([regextestmobiletwo evaluateWithObject:numberPass]) {
            NSLog(@"不能6位一样");
            backnumber=@"密码为6位不相同且不连续";
        }else{
            int sam0=0;
            //int sameone=0;
            NSMutableArray *array=[[NSMutableArray alloc]init];
            for (int i=0; i<numberPass.length; i++) {
                NSString *number=[numberPass substringWithRange:NSMakeRange(i,1)];
                [array addObject:number];
            }
            for (int b=0;b<array.count-1;b++) {
                if (array[array.count-1]>array[0]) {
                    // 顺序
                    if ([array[b] intValue]+1==[array[b+1] intValue]) {
                        sam0++;
                    }else{
                        break;
                    }
                }else{
                    // 倒叙
                    if ([array[b] intValue]-1==[array[b+1] intValue]) {
                        sam0++;
                    }else{
                        break;
                    }
                }
            }
            if (sam0==5) {
                NSLog(@"不可以连续");
                backnumber=@"支付密码不能连续";
            }
        }
    }else{
        backnumber=@"支付密码不能少于6位";
    }
    return backnumber;
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

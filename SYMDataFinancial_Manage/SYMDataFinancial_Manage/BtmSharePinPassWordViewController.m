//
//  BtmSharePinPassWordViewController.m
//  BitMainWallet_Hot
//
//  Created by cuiyong on 15/6/22.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import "BtmSharePinPassWordViewController.h"

#import "PwdView.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AdSupport/ASIdentifierManager.h>
#import "SYMCustomButton.h"
#import "SYMConstantCenter.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMSecurityWebViewController.h"
#import "SYMPublicDictionary.h"
#import "SYMDataBaseModel.h"
#import "SYMInformationSave.h"
#import "SYMBackpayPasswordViewController.h"
#import "SYMTabController.h"

#define MainScreenWidth    [UIScreen mainScreen].bounds.size.width
#define MainscreenHeight   [UIScreen mainScreen].bounds.size.height
#define RaiotHeight  (BTMHeight>568?BTMHeight/568:1)

/*
 201 --发送
 301 --设置
 401 --输入
 */
@interface BtmSharePinPassWordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIImageView * MainImageview;
    UIView *MainView;
    int  manyTimes;
    float BTCAcountS;
    float poundage;
    PwdView * pwdView;
    UITextField * pwdTextField;
    UILabel *errorLabel;
    UIImageView *tipview;
    BOOL isaway;
    UILabel *poundageLabel;
    NSString *savepassword;
    UILabel *titleLabel;
    UIImageView *separationLine;
    // UIViewController *mainController;
}

@end

@implementation BtmSharePinPassWordViewController

-(id)init{
    if (self = [super init]) {
        //
        //        blcok @"11111"
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.7f]];
    manyTimes = 5;
    poundage = 0.00001;// 手续费
}
/**
 *  根据系统每个版本选择不同的model推出方式
 */
-(void)defaultStandPinPassword:(UIViewController *)viewcontroller;
{
    // mainController=viewcontroller;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        viewcontroller.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    if (self.backPassword) {
        NSLog(@"11111111111");
        self.backPassword(@"1111");
    }
}

-(void)initViewcontrolsNorealname
{
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*SYMWIDthRATESCALE,130*RaiotHeight,MainScreenWidth-48*SYMWIDthRATESCALE, MainscreenHeight-160*RaiotHeight-190*RaiotHeight)];
    MainImageview.userInteractionEnabled=YES;
    MainImageview.image=[UIImage imageNamed:@"tankuang_jiaoyijine"];
    [self.view addSubview:MainImageview];
}

-(void)initViewcontrols
{
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*SYMWIDthRATESCALE,130*RaiotHeight,MainScreenWidth-48*SYMWIDthRATESCALE, MainscreenHeight-160*RaiotHeight-190*RaiotHeight)];
    MainImageview.userInteractionEnabled=YES;
    MainImageview.image=[UIImage imageNamed:@"tankuang_zhifumima"];
    [self.view addSubview:MainImageview];
}

//点击创建新钱包按钮就会调用此方法
-(void)initLoginViewcontrols
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-initLoginViewcontrols-方法");
    
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight,160*RaiotHeight,MainScreenWidth-48*RaiotHeight, MainscreenHeight-160*RaiotHeight-240*RaiotHeight)];
    
    MainImageview.layer.cornerRadius = 8;
    MainImageview.layer.masksToBounds = YES;
    
    MainImageview.userInteractionEnabled=YES;
    
    MainImageview.image=[UIImage imageNamed:@"send_tips_bg"];
    
    [self.view addSubview:MainImageview];
}

-(void)initInputViewcontrols
{
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight,160*RaiotHeight,MainScreenWidth-48*RaiotHeight, MainscreenHeight-160*RaiotHeight-250*RaiotHeight)];
    MainImageview.image=[UIImage imageNamed:@"tankuang_zhifumima"];
    MainImageview.userInteractionEnabled=YES;
    [self.view addSubview:MainImageview];
}

-(void)initInviteCodeViewcontrols
{
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight,160*RaiotHeight,MainScreenWidth-48*RaiotHeight, MainscreenHeight-160*RaiotHeight-250*RaiotHeight)];
    MainImageview.image=[UIImage imageNamed:@"tankuang_zhifumima"];
    MainImageview.userInteractionEnabled=YES;
    [self.view addSubview:MainImageview];
}

-(void)initHelpCardViewcontrols
{
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight,160*RaiotHeight,MainScreenWidth-48*RaiotHeight, MainscreenHeight-160*RaiotHeight-250*RaiotHeight)];
    MainImageview.image=[UIImage imageNamed:@"tankuang_zhifumima"];
    MainImageview.userInteractionEnabled=YES;
    [self.view addSubview:MainImageview];
}

-(void)initTransactionViewcontrols
{
    MainImageview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight,160*RaiotHeight,MainScreenWidth-48*RaiotHeight, MainscreenHeight-160*RaiotHeight-250*RaiotHeight)];
    MainImageview.image=[UIImage imageNamed:@"tankuang_zhifumima"];
    MainImageview.userInteractionEnabled=YES;
    [self.view addSubview:MainImageview];
}


-(void)setControlsInMainImageview
{
    // 设置关闭按钮
    SYMCustomButton *colseButton=[SYMCustomButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake(10*SYMWIDthRATESCALE, 15*RaiotHeight, 10*SYMWIDthRATESCALE, 10*RaiotHeight);
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
    //设置标题label
    UILabel *titleLabelSond=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-150*SYMWIDthRATESCALE)/2, 15*RaiotHeight, 150*SYMWIDthRATESCALE, 16*RaiotHeight)];
    titleLabelSond.text=@"请输入交易密码";
    titleLabelSond.textAlignment = NSTextAlignmentCenter;
    titleLabelSond.font=[UIFont systemFontOfSize:16*RaiotHeight];
    titleLabelSond.textColor=SYMFontblackColor;
    [MainImageview addSubview:titleLabelSond];
    
    // 设置分割线
    separationLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabelSond.frame.origin.y+titleLabelSond.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    UIImage * image = [UIImage imageNamed:@"tankuang_xian"];
    separationLine.image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [MainImageview addSubview:separationLine];
    
    // 设置发送提示文字
    UILabel * sendTipsLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-80*SYMWIDthRATESCALE)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+13*RaiotHeight), 80*SYMWIDthRATESCALE, 12*RaiotHeight)];
    sendTipsLabel.text = @"交易金额";
    sendTipsLabel.textAlignment = NSTextAlignmentCenter;
    sendTipsLabel.font=[UIFont systemFontOfSize:13*RaiotHeight];
    sendTipsLabel.textColor=SYMFontblackColor;
    [MainImageview addSubview:sendTipsLabel];
    
    // 设置发送BTC
    UILabel *BTCLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-160*SYMWIDthRATESCALE)/2,(sendTipsLabel.frame.origin.y+sendTipsLabel.bounds.size.height+10*RaiotHeight), 160*SYMWIDthRATESCALE, 21*RaiotHeight)];
    
    BTCLabel.text=[NSString stringWithFormat:@"￥%@",self.sendmoney];
    BTCLabel.textAlignment = NSTextAlignmentCenter;
    BTCLabel.font=[UIFont systemFontOfSize:27*RaiotHeight];
    BTCLabel.textColor=SYMFontblackColor;
    [MainImageview addSubview:BTCLabel];
    
    // 设置手续费
    poundageLabel=[[UILabel alloc]initWithFrame:CGRectMake(16*SYMWIDthRATESCALE,(BTCLabel.frame.origin.y+BTCLabel.bounds.size.height+13*RaiotHeight), 120*SYMWIDthRATESCALE, 12*RaiotHeight)];
    poundageLabel.text=[NSString stringWithFormat:@"%@(%@)付款",self.bankName,self.cardNo];
    //@"使用工商银行(0060)付款";
    //[NSString stringWithFormat:@"使用工商银行(0060)付款%@%.5f",NSLocalizedString(@"poundageLabel", nil),poundage];
    poundageLabel.textAlignment = NSTextAlignmentLeft;
    poundageLabel.font=[UIFont systemFontOfSize:11*RaiotHeight];
    poundageLabel.textColor=SYMBLUECOLOR;
    [MainImageview addSubview:poundageLabel];
    
    // 设置手续费
    UILabel *poundageMoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(16*SYMWIDthRATESCALE+120*SYMWIDthRATESCALE+8*SYMWIDthRATESCALE,(BTCLabel.frame.origin.y+BTCLabel.bounds.size.height+13*RaiotHeight), 80*RaiotHeight, 12*RaiotHeight)];
    poundageMoreLabel.text=[NSString stringWithFormat:@"%@",self.memo];
    //@"单笔/单日5万元";
    //[NSString stringWithFormat:@"使用工商银行(0060)付款%@%.5f",NSLocalizedString(@"poundageLabel", nil),poundage];
    poundageMoreLabel.textAlignment = NSTextAlignmentLeft;
    poundageMoreLabel.font=[UIFont systemFontOfSize:11*RaiotHeight];
    poundageMoreLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [MainImageview addSubview:poundageMoreLabel];
    
    //设置输入错误提示
    errorLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-180*SYMWIDthRATESCALE)/2, (poundageMoreLabel.frame.origin.y+poundageMoreLabel.bounds.size.height+6*RaiotHeight), 180*SYMWIDthRATESCALE, 11*RaiotHeight)];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font=[UIFont systemFontOfSize:11*RaiotHeight];
    errorLabel.textColor=[UIColor colorWithRed:249/255.0f green:34/255.0f blue:43/255.0f alpha:1];
    [MainImageview addSubview:errorLabel];
    
    // 密码输入框
    [self initTextField];
}


-(void)setNotReslNameControlsInMainImageview
{
    // 设置关闭按钮
    SYMCustomButton *colseButton=[SYMCustomButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake(10*SYMWIDthRATESCALE, 15*RaiotHeight, 10*SYMWIDthRATESCALE, 10*RaiotHeight);
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
    //设置标题label
    UILabel *titleLabelSond=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-150*SYMWIDthRATESCALE)/2, 15*RaiotHeight, 150*SYMWIDthRATESCALE, 16*RaiotHeight)];
    titleLabelSond.text=@"请输入交易密码";
    titleLabelSond.textAlignment = NSTextAlignmentCenter;
    titleLabelSond.font=[UIFont systemFontOfSize:16*RaiotHeight];
    titleLabelSond.textColor=SYMFontblackColor;
    [MainImageview addSubview:titleLabelSond];
    
    // 设置分割线
    separationLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabelSond.frame.origin.y+titleLabelSond.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    UIImage * image = [UIImage imageNamed:@"tankuang_xian"];
    separationLine.image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [MainImageview addSubview:separationLine];
    
    // 设置发送提示文字
    UILabel * sendTipsLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-80*SYMWIDthRATESCALE)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+13*RaiotHeight), 80*SYMWIDthRATESCALE, 12*RaiotHeight)];
    sendTipsLabel.text = @"交易金额";
    sendTipsLabel.textAlignment = NSTextAlignmentCenter;
    sendTipsLabel.font=[UIFont systemFontOfSize:13*RaiotHeight];
    sendTipsLabel.textColor=SYMFontblackColor;
    [MainImageview addSubview:sendTipsLabel];
    
    // 设置发送BTC
    UILabel *BTCLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-160*SYMWIDthRATESCALE)/2,(sendTipsLabel.frame.origin.y+sendTipsLabel.bounds.size.height+10*RaiotHeight), 160*SYMWIDthRATESCALE, 21*RaiotHeight)];
    
    BTCLabel.text=[NSString stringWithFormat:@"￥%@",self.sendmoney];
    BTCLabel.textAlignment = NSTextAlignmentCenter;
    BTCLabel.font=[UIFont systemFontOfSize:27*RaiotHeight];
    BTCLabel.textColor=SYMFontblackColor;
    [MainImageview addSubview:BTCLabel];
    
    //设置输入错误提示
    errorLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-180*SYMWIDthRATESCALE)/2, (BTCLabel.frame.origin.y+BTCLabel.bounds.size.height+6*RaiotHeight), 180*SYMWIDthRATESCALE, 11*RaiotHeight)];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font=[UIFont systemFontOfSize:11*RaiotHeight];
    errorLabel.textColor=[UIColor colorWithRed:249/255.0f green:34/255.0f blue:43/255.0f alpha:1];
    [MainImageview addSubview:errorLabel];
    // 密码输入框
    [self initNotRealNameTextField];
}




-(void)setLoginPINControlsInMainImageview
{
    
    NSLog(@"调用了BtmSharePinPassWordViewController中的-setLoginPINControlsInMainImageview-方法");
    
    // 设置关闭按钮
    UIButton *colseButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    colseButton.frame=CGRectMake(10*RaiotHeight, 15*RaiotHeight, 10*RaiotHeight, 10*RaiotHeight);
    
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    
    //[colseButton setBackgroundImage:[UIImage imageNamed:@"send_btn02_delete_press"] forState:UIControlStateSelected];
    
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [MainImageview addSubview:colseButton];
    
    
    //设置标题label
    
    NSLog(@"高度：%f",15*RaiotHeight);  // 19.436620
    
    //UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(MainImageview.bounds.size.width/2-50, 15, 100, 14)];
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-100*RaiotHeight)/2, 15*RaiotHeight, 100*RaiotHeight, 16*RaiotHeight)];
    
    titleLabel.text=NSLocalizedString(@"titleLabel", nil);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.font=[UIFont systemFontOfSize:16*RaiotHeight];
    
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.7];
    
    [MainImageview addSubview:titleLabel];
    
    
    // 设置分割线
    separationLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabel.frame.origin.y+titleLabel.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    
    separationLine.image=[UIImage imageNamed:@"tankuang_xian"];
    
    [MainImageview addSubview:separationLine];
    
    
    //设置输入错误提示
    
    errorLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-180*RaiotHeight)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+6*RaiotHeight), 180*RaiotHeight, 11*RaiotHeight)];
    
    errorLabel.text=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"errorLabel", nil),manyTimes,NSLocalizedString(@"errorLabel", nil)];
    
    errorLabel.textAlignment = NSTextAlignmentCenter;
    
    errorLabel.font=[UIFont systemFontOfSize:11*RaiotHeight];
    
    errorLabel.textColor=[UIColor colorWithRed:249/255.0f green:34/255.0f blue:43/255.0f alpha:1];
    
    [MainImageview addSubview:errorLabel];
    
    
    // 设置发送提示文字
    
    UILabel *sendTipsLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-40*RaiotHeight)/2, (errorLabel.frame.origin.y+errorLabel.bounds.size.height+8*RaiotHeight), 40*RaiotHeight, 12*RaiotHeight)];
    sendTipsLabel.text=NSLocalizedString(@"sendTipsLabel", nil);
    sendTipsLabel.textAlignment = NSTextAlignmentCenter;
    sendTipsLabel.font=[UIFont systemFontOfSize:12*RaiotHeight];
    sendTipsLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    //[MainImageview addSubview:sendTipsLabel];
    
    
    
    // 设置发送BTC
    
    UILabel *BTCLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-100*RaiotHeight)/2,(sendTipsLabel.frame.origin.y+sendTipsLabel.bounds.size.height+6*RaiotHeight), 100*RaiotHeight, 21*RaiotHeight)];
    
    //BTCLabel.text=[NSString stringWithFormat:@"%.2fBTC",BTCAcountS];
    
    BTCLabel.textAlignment = NSTextAlignmentCenter;
    
    BTCLabel.font=[UIFont systemFontOfSize:21*RaiotHeight];
    
    BTCLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    
    //[MainImageview addSubview:BTCLabel];
    
    //  设置底部分割线
    
    UIImageView *bottomLineImageivew=[[UIImageView alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-(MainImageview.bounds.size.width-20*RaiotHeight))/2,(BTCLabel.frame.origin.y+BTCLabel.bounds.size.height+12*RaiotHeight), MainImageview.bounds.size.width-20*RaiotHeight, 1*RaiotHeight)];
    
    
    bottomLineImageivew.image=[UIImage imageNamed:@"send_enterPassword_drive"];
    
    //    [MainImageview addSubview:bottomLineImageivew];
    
    // 设置手续费
    
    poundageLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-100*RaiotHeight)/2,(bottomLineImageivew.frame.origin.y+bottomLineImageivew.bounds.size.height+6*RaiotHeight), 100*RaiotHeight, 12*RaiotHeight)];
    
    poundageLabel.text=[NSString stringWithFormat:@"手续费%.5f",poundage];
    
    poundageLabel.textAlignment = NSTextAlignmentCenter;
    
    poundageLabel.font=[UIFont systemFontOfSize:12*RaiotHeight];
    
    poundageLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    
    //[MainImageview addSubview:poundageLabel];
    
    // 密码输入框
    
    [self initLoginPINTextField];
    
    
}


-(void)setInputPINControlsInMainImageview
{
    // 设置关闭按钮
    SYMCustomButton *colseButton=[SYMCustomButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake(15*SYMWIDthRATESCALE, 15*RaiotHeight, 10*SYMWIDthRATESCALE, 10*RaiotHeight);
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
    //设置标题label
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-100*SYMWIDthRATESCALE)/2, 15*RaiotHeight, 120*SYMWIDthRATESCALE, 16*RaiotHeight)]; // SYMWIDthRATESCALE
    titleLabel.text=@"请输入支付密码";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:15*RaiotHeight];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.7];
    [MainImageview addSubview:titleLabel];
    
    // 设置分割线
    separationLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabel.frame.origin.y+titleLabel.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    separationLine.image=[UIImage imageNamed:@"tankuang_xian"];
    [MainImageview addSubview:separationLine];
    
    
    //设置输入错误提示
    errorLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-180*RaiotHeight)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+6*RaiotHeight), 180*RaiotHeight, 11*RaiotHeight)];
    //errorLabel.text=@"PIN码不正确";
    //[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"errorLabel", nil),manyTimes,NSLocalizedString(@"timeS", nil)];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.font=[UIFont systemFontOfSize:11*RaiotHeight];
    errorLabel.textColor=[UIColor colorWithRed:249/255.0f green:34/255.0f blue:43/255.0f alpha:1];
    [MainImageview addSubview:errorLabel];
    // 密码输入框
    [self initInputPINTextField];
}


-(void)setInviteCodeControlsInMainImageview
{
    // 设置关闭按钮
    SYMCustomButton *colseButton=[SYMCustomButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake(15*SYMWIDthRATESCALE, 15*RaiotHeight, 10*SYMWIDthRATESCALE, 10*RaiotHeight);
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
    //设置标题label
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-100*SYMWIDthRATESCALE)/2, 15*RaiotHeight, 120*SYMWIDthRATESCALE, 16*RaiotHeight)]; // SYMWIDthRATESCALE
    titleLabel.text=@"什么是邀请码？";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:15*RaiotHeight];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.7];
    [MainImageview addSubview:titleLabel];
    
    // 设置分割线
    separationLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabel.frame.origin.y+titleLabel.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    separationLine.image=[UIImage imageNamed:@"tankuang_xian"];
    [MainImageview addSubview:separationLine];
    
    
    //设置输入错误提示
    UILabel *information=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-210*RaiotHeight)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+6*RaiotHeight), 210*RaiotHeight, 100*RaiotHeight)];
    information.contentMode = UIViewContentModeScaleAspectFit;
    information.numberOfLines = 0; // 最关键的一句
    information.text=@"邀请码为注册会员时使用，是和理财\n用户或您的好友分享给您的，使用该\n邀请号注册，可给予邀请好友返利\n优惠。";
    information.textAlignment = NSTextAlignmentLeft;
    information.font=[UIFont systemFontOfSize:13*RaiotHeight];
    information.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [MainImageview addSubview:information];
}

-(void)setHelpCardControlsInMainImageview
{
    // 设置关闭按钮
    SYMCustomButton *colseButton=[SYMCustomButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake(15*SYMWIDthRATESCALE, 15*RaiotHeight, 10*SYMWIDthRATESCALE, 10*RaiotHeight);
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
    //设置标题label
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-60*SYMWIDthRATESCALE)/2, 10*RaiotHeight, 80*SYMWIDthRATESCALE, 10*RaiotHeight)]; // SYMWIDthRATESCALE
    titleLabel.text=@"未帮卡";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font=[UIFont systemFontOfSize:15*RaiotHeight];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [MainImageview addSubview:titleLabel];
    
    // 设置分割线
    separationLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabel.frame.origin.y+titleLabel.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    separationLine.image=[UIImage imageNamed:@"tankuang_xian"];
    [MainImageview addSubview:separationLine];
    
    
    //设置输入错误提示
    UILabel *information=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-140*RaiotHeight)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+29*RaiotHeight), 140*RaiotHeight, 40*RaiotHeight)];
    information.numberOfLines = 0; // 最关键的一句
    information.text=@"您未购买过理财产品,\n     马上购买吧";
    information.textAlignment = NSTextAlignmentLeft;
    information.font=[UIFont systemFontOfSize:14*RaiotHeight];
    information.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [MainImageview addSubview:information];
    
    // 确定按钮
    UIButton *determineButton=[UIButton buttonWithType:UIButtonTypeSystem];
    determineButton.frame=CGRectMake(0, (information.frame.origin.y+information.bounds.size.height+36*RaiotHeight), MainImageview.bounds.size.width, 30*RaiotHeight);
    [determineButton setTitle:@"好的" forState:UIControlStateNormal];
    determineButton.titleLabel.font=[UIFont systemFontOfSize:18.0f];
    [determineButton setTintColor:[UIColor whiteColor]];
    //[determineButton setBackgroundColor:[UIColor blueColor]];
    [determineButton setBackgroundImage:[UIImage imageNamed:@"btn_tankuang"] forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:determineButton];
}

-(void)setTransactionControlsInMainImageview
{
    // 设置关闭按钮
    SYMCustomButton *colseButton=[SYMCustomButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake(15*SYMWIDthRATESCALE, 15*RaiotHeight, 10*SYMWIDthRATESCALE, 10*RaiotHeight);
    [colseButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [colseButton setBackgroundImage:[UIImage imageNamed:@"tankuang_guanbi"] forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
    //设置标题label
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-120*SYMWIDthRATESCALE)/2, 15*RaiotHeight, 120*SYMWIDthRATESCALE, 16*RaiotHeight)]; // SYMWIDthRATESCALE
    titleLabel.text=@"交易记录";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:15*RaiotHeight];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.7];
    [MainImageview addSubview:titleLabel];
    
    // 设置分割线
    separationLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, (titleLabel.frame.origin.y+titleLabel.bounds.size.height+10*RaiotHeight), MainImageview.bounds.size.width, 1*RaiotHeight)];
    separationLine.image=[UIImage imageNamed:@"tankuang_xian"];
    [MainImageview addSubview:separationLine];
    
    
    //设置输入错误提示
    UILabel *information=[[UILabel alloc]initWithFrame:CGRectMake((MainImageview.bounds.size.width-210*RaiotHeight)/2, (separationLine.frame.origin.y+separationLine.bounds.size.height+6*RaiotHeight), 210*RaiotHeight, 100*RaiotHeight)];
    information.contentMode = UIViewContentModeScaleAspectFit;
    information.numberOfLines = 0; // 最关键的一句
    //information.text=@"邀请码为注册会员时使用，是和理财\n用户或您的好友分享给您的，使用该\n邀请号注册，可给予邀请好友返利\n优惠。";
    information.text=@"抱歉，无交易记录";
    information.textAlignment = NSTextAlignmentCenter;
    information.font=[UIFont systemFontOfSize:13*RaiotHeight];
    information.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [MainImageview addSubview:information];
}

-(void)initTextField
{
    [self registerForKeyboardNotifications];
    //初始化界面
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(16*SYMWIDthRATESCALE, (poundageLabel.frame.origin.y+poundageLabel.bounds.size.height+29*RaiotHeight),(MainImageview.bounds.size.width - 32*SYMWIDthRATESCALE), 35*RaiotHeight)];
    
    pwdTextField.tag=201;
    
    [pwdTextField becomeFirstResponder];
    
    pwdTextField.delegate = self;
    
    pwdTextField.backgroundColor = [UIColor yellowColor];
    
    pwdTextField.tintColor = pwdTextField.backgroundColor;
    
    [pwdTextField setTextColor:pwdTextField.backgroundColor];
    
    pwdTextField.alpha = 0.1;
    
    pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [MainImageview addSubview:pwdTextField];
    
    pwdView = [[PwdView alloc] initWithFrame:pwdTextField.frame];
    
    [[pwdView layer] setBorderWidth:0.8f];
    
    // [UIColor colorWithRed:134/255.0f green:139/255.0f blue:142/255.0f alpha:1]
    
    [[pwdView layer] setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1].CGColor];//颜色
    pwdView.layer.cornerRadius=5;
    pwdView.layer.masksToBounds = YES;
    pwdView.backgroundColor =[UIColor whiteColor];
    pwdView.userInteractionEnabled = NO;
    
    pwdView.pwdCount=6;
    
    [MainImageview addSubview:pwdView];
    
    // 添加忘记密码按钮
    UIButton *colseButton=[UIButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake((MainImageview.bounds.size.width - 94*SYMWIDthRATESCALE),pwdTextField.frame.origin.y+pwdTextField.frame.size.height+12*RaiotHeight, 100*RaiotHeight, 10*RaiotHeight);
    colseButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    colseButton.titleLabel.textColor=SYMBLUECOLOR;
    [colseButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
}


-(void)initNotRealNameTextField
{
    [self registerForKeyboardNotifications];
    //初始化界面
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(16*SYMWIDthRATESCALE, (errorLabel.frame.origin.y+errorLabel.bounds.size.height+13*RaiotHeight),(MainImageview.bounds.size.width - 32*SYMWIDthRATESCALE), 35*RaiotHeight)];
    
    pwdTextField.tag=501;
    
    [pwdTextField becomeFirstResponder];
    
    pwdTextField.delegate = self;
    
    pwdTextField.backgroundColor = [UIColor yellowColor];
    
    pwdTextField.tintColor = pwdTextField.backgroundColor;
    
    [pwdTextField setTextColor:pwdTextField.backgroundColor];
    
    pwdTextField.alpha = 0.1;
    
    pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [MainImageview addSubview:pwdTextField];
    
    pwdView = [[PwdView alloc] initWithFrame:pwdTextField.frame];
    
    [[pwdView layer] setBorderWidth:0.8f];
    
    // [UIColor colorWithRed:134/255.0f green:139/255.0f blue:142/255.0f alpha:1]
    
    [[pwdView layer] setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1].CGColor];//颜色
    pwdView.layer.cornerRadius=5;
    pwdView.layer.masksToBounds = YES;
    pwdView.backgroundColor =[UIColor whiteColor];
    pwdView.userInteractionEnabled = NO;
    
    pwdView.pwdCount=6;
    
    [MainImageview addSubview:pwdView];
    
    // 添加忘记密码按钮
    UIButton *colseButton=[UIButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake((MainImageview.bounds.size.width - 94*SYMWIDthRATESCALE),pwdTextField.frame.origin.y+pwdTextField.frame.size.height+12*RaiotHeight, 100*RaiotHeight, 10*RaiotHeight);
    colseButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    colseButton.titleLabel.textColor=SYMBLUECOLOR;
    [colseButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
}


-(void)initLoginPINTextField
{
    [self registerForKeyboardNotifications];
    //初始化界面
    pwdTextField =[[UITextField alloc] initWithFrame:CGRectMake(10*RaiotHeight, (errorLabel.frame.origin.y+errorLabel.bounds.size.height+8*RaiotHeight), (MainImageview.bounds.size.width - 20*RaiotHeight), 40*RaiotHeight)];
    
    pwdTextField.tag=301;
    
    [pwdTextField becomeFirstResponder];
    
    pwdTextField.delegate = self;
    
    pwdTextField.tintColor = pwdTextField.backgroundColor;
    
    [pwdTextField setTextColor:pwdTextField.backgroundColor];
    
    pwdTextField.alpha = 0.1;
    
    pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [MainImageview addSubview:pwdTextField];
    
    //设置输入pin码提示框
    pwdView = [[PwdView alloc]init];
    pwdView.frame = pwdTextField.frame;
    
    if (MainscreenHeight == 480) {
        CGFloat pwdViewX = pwdTextField.frame.origin.x;
        CGFloat pwdViewY = pwdTextField.frame.origin.y;
        CGFloat pwdViewW = pwdTextField.frame.size.width;
        CGFloat pwdViewH = pwdTextField.frame.size.height + 7;
        pwdView.frame = CGRectMake(pwdViewX, pwdViewY, pwdViewW, pwdViewH);
    }
    
    
    
    //    pwdView = [[PwdView alloc] initWithFrame:pwdTextField.frame];
    
    [[pwdView layer] setBorderWidth:1];
    
    [[pwdView layer] setBorderColor:[UIColor colorWithRed:134/255.0f green:139/255.0f blue:142/255.0f alpha:1].CGColor];//颜色
    
    pwdView.layer.cornerRadius=5;
    
    pwdView.layer.masksToBounds = YES;
    
    pwdView.backgroundColor =[UIColor whiteColor];
    
    pwdView.userInteractionEnabled = NO;
    
    pwdView.pwdCount=6;
    
    [MainImageview addSubview:pwdView];
    
    NSLog(@"pwdView--->>>%@",[pwdView subviews]);
    
}

-(void)initInputPINTextField
{
    
    [self registerForKeyboardNotifications];
    //初始化界面
    pwdTextField =[[UITextField alloc] initWithFrame:CGRectMake(16*SYMWIDthRATESCALE, (errorLabel.frame.origin.y+errorLabel.bounds.size.height+8*RaiotHeight), (MainImageview.bounds.size.width - 32*SYMWIDthRATESCALE), 40*RaiotHeight)];
    pwdTextField.tag=401;
    [pwdTextField becomeFirstResponder];
    pwdTextField.delegate = self;
    //pwdTextField.backgroundColor = [UIColor yellowColor];
    pwdTextField.tintColor = pwdTextField.backgroundColor;
    [pwdTextField setTextColor:pwdTextField.backgroundColor];
    pwdTextField.alpha = 0.1;
    pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    [MainImageview addSubview:pwdTextField];
    pwdView = [[PwdView alloc] initWithFrame:pwdTextField.frame];
    [[pwdView layer] setBorderWidth:0.8f];
    //[[pwdView layer] setBorderColor:[UIColor colorWithRed:134/255.0f green:139/255.0f blue:142/255.0f alpha:1].CGColor];//颜色
    [[pwdView layer] setBorderColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1].CGColor];//颜色
    pwdView.layer.cornerRadius=5;
    pwdView.layer.masksToBounds = YES;
    pwdView.backgroundColor =[UIColor whiteColor];
    pwdView.userInteractionEnabled = NO;
    pwdView.pwdCount=6;
    [MainImageview addSubview:pwdView];
    
    // 添加忘记密码按钮
    UIButton *colseButton=[UIButton buttonWithType:UIButtonTypeSystem];
    colseButton.frame=CGRectMake((MainImageview.bounds.size.width - 94*SYMWIDthRATESCALE),pwdTextField.frame.origin.y+pwdTextField.frame.size.height+12*RaiotHeight, 100*RaiotHeight, 10*RaiotHeight);
    colseButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    colseButton.titleLabel.textColor=SYMBLUECOLOR;
    [colseButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [colseButton addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [MainImageview addSubview:colseButton];
    
}


- (void) registerForKeyboardNotifications
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-registerForKeyboardNotifications-方法");
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
    NSLog(@"调用了BtmSharePinPassWordViewController中的-keyboardWillShow-方法");
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    
    NSLog(@"键盘高度-->%d",height);
    
    CGRect textfieldbounds;
    
    textfieldbounds=MainImageview.frame;
    if (MainscreenHeight-(MainImageview.frame.origin.y+MainImageview.bounds.size.height)<height) {
        
        float moveheight=height-(MainscreenHeight-(MainImageview.frame.origin.y+MainImageview.bounds.size.height));
        
        NSLog(@"moveheight:%f",moveheight);
        
        [UIView animateWithDuration:0.3f animations:^{
            
            MainImageview.transform = CGAffineTransformMakeTranslation(0,-moveheight-5);
            
        }];
        
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView  animateWithDuration:0.3f animations:^{
        
        MainImageview.transform = CGAffineTransformMakeTranslation(0,0);
        
    }];
}

/**
 *  输入pin左上角的关闭按钮的监听方法
 */
- (void)CloseClick:(UIButton *)button
{
    
    [UIView animateWithDuration:0.3f animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    if (self.close) {
        self.close();
    }
}
/**
 *  确定按钮
 */
-(void)determineClick:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.3f animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    if (self.backPassword) {
        self.backPassword(@"a");
    }
}

#pragma mark- 忘记密码
-(void)forgetClick:(UIButton *)button{
    NSLog(@"忘记密码");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.forgetpassword) {
        self.forgetpassword();
    }
}

//监听输入框中输入的文字   让自定义的UIView画图
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==301) {
        // 登陆设置密码
        NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        NSLog(@"str--->%@---->>>>%ld",str,(long)textField.tag);
        if (str.length >=pwdView.pwdCount)
        {
            [pwdView setCount:str.length];
            [pwdTextField setText:[str substringToIndex:pwdView.pwdCount]];
            
            // 清空textfield
            // 修改标题
            if ([titleLabel.text isEqualToString:@"设置PIN码"])
            {
                //  必须得用延迟 才能打到输入6个点
                [self performSelector:@selector(timeoutClickShow) withObject:nil afterDelay:0.5];
            }
            else
            {
                
                if ([pwdTextField.text isEqualToString:savepassword])
                {
                    //  跳转到主页啦
                    if (_backPassword)
                    {
                        _backPassword(pwdTextField.text);
                    }
                    
                    if (_requestback)
                    {
                        // _requestback(pwdTextField.text,[[KeyHandle defautKey] checkSeedByScriptSeed:[[NSUserDefaults standardUserDefaults]objectForKey:BTMSIGNED_SEED] Password:pwdTextField.text]);
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [MainImageview removeFromSuperview];
                    MainImageview=nil;
                    
                }
                else
                {
                    errorLabel.text=NSLocalizedString(@"errorLabelToo", nil);
                    
                    [errorLabel setHidden:NO];
                    
                    [self performSelector:@selector(timeoutClick) withObject:nil afterDelay:1];
                    
                    [pwdTextField endEditing:NO];
                    
                }
            }
            
            return NO;
        }
        else
        {
            if ([string isEqualToString:@""])
            {
                [pwdView setCount:str.length - 1];
            }
            else
            {
                [pwdView setCount:str.length];
            }
        }
    }
    else if (textField.tag==401)
    {
        NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        NSLog(@"str--->%@",str);
        if (str.length >=pwdView.pwdCount) {
            [pwdView setCount:str.length];
            [pwdTextField setText:[str substringToIndex:pwdView.pwdCount]];
            [self judgeIStrue:pwdTextField.text];
            
            
            //            if ([self judgeIStrue:pwdTextField.text])
            //            {
            //
            //                if (_backPassword)
            //                {
            //                    _backPassword(pwdTextField.text);
            //                }
            //
            //                [UIView animateWithDuration:0.3f animations:^{
            //                    [self dismissViewControllerAnimated:YES completion:nil];
            //                    [MainImageview removeFromSuperview];
            //                    MainImageview=nil;
            //                }];
            //
            //            }
            //            else
            //            {
            //                [self performSelector:@selector(timeoutClick) withObject:nil afterDelay:1];
            //                [pwdTextField endEditing:NO];
            //            }
            
            
        }
        else
        {
            
            if ([string isEqualToString:@""])
            {
                [pwdView setCount:str.length - 1];
            }
            else
            {
                [pwdView setCount:str.length];
            }
        }
    }else if (textField.tag==501){
        
        NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        // 输入的长度是否小于输入密码个数
        if (str.length >=pwdView.pwdCount)
        {
            [pwdView setCount:str.length];
            [pwdTextField setText:[str substringToIndex:pwdView.pwdCount]];
            //判断输入密码是否正确
            [self judgeIStrue:pwdTextField.text];
            
            //            if ([self judgeIStrue:pwdTextField.text])
            //            {
            //                if (_backPassword)
            //                {
            //                    _backPassword(pwdTextField.text);
            //                }
            //                [UIView animateWithDuration:0.3f animations:^{
            //                    [self dismissViewControllerAnimated:YES completion:nil];
            //                    [MainImageview removeFromSuperview];
            //                    MainImageview=nil;
            //                }];
            //            }
            //            else
            //            {
            //                // 输入不正确执行
            //                [self performSelector:@selector(timeoutClick) withObject:nil afterDelay:1];
            //                [pwdTextField endEditing:NO];
            //            }
            
        }
        
        else
        {
            // 输入长度不足
            if ([string isEqualToString:@""])
            {
                [pwdView setCount:str.length - 1];
            }
            else
            {
                [pwdView setCount:str.length];
            }
        }
        
    }
    
    
    else if (textField.tag==201) // 发送
    {
        NSString * str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        NSLog(@"str--->%@",str);
        // 输入的长度是否小于输入密码个数
        if (str.length >=pwdView.pwdCount)
        {
            [pwdView setCount:str.length];
            [pwdTextField setText:[str substringToIndex:pwdView.pwdCount]];
            //判断输入密码是否正确
            [self judgeIStrue:pwdTextField.text];
            //            if ([self judgeIStrue:pwdTextField.text])
            //            {
            //                // 进行购买操作
            //
            //                if (_backPassword)
            //                {
            //                    _backPassword(pwdTextField.text);
            //                }
            //                [UIView animateWithDuration:0.3f animations:^{
            //                    [self dismissViewControllerAnimated:YES completion:nil];
            //                    [MainImageview removeFromSuperview];
            //                    MainImageview=nil;
            //                }];
            //            }
            //            else
            //            {
            //                // 输入不正确执行
            //                [self performSelector:@selector(timeoutClick) withObject:nil afterDelay:1];
            //                [pwdTextField endEditing:NO];
            //            }
        }
        
        else
        {
            // 输入长度不足
            if ([string isEqualToString:@""])
            {
                [pwdView setCount:str.length - 1];
            }
            else
            {
                [pwdView setCount:str.length];
            }
        }
    }
    return YES;
}

#pragma mark- 密码输入不正确的时候调用的
-(void)timeoutClick
{
    [pwdView setCount:0];
    pwdTextField.text=@"";
    [errorLabel setHidden:YES];
    [pwdTextField becomeFirstResponder];
}

-(void)timeOUtInput
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-timeOUtInput-方法");
    
    [pwdView setCount:0];
    
    pwdTextField.text=@"";
    
    [errorLabel setHidden:YES];
    //[pwdTextField becomeFirstResponder];
    
}

-(void)timeoutClickShow
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-timeoutClickShow-方法");
    
    [pwdView setCount:0];
    
    savepassword=pwdTextField.text;
    
    pwdTextField.text=@"";
    
    [pwdTextField endEditing:NO];
    
    titleLabel.text=NSLocalizedString(@"titleLabelToo", nil);
    
    [pwdTextField becomeFirstResponder];
    
}

-(void)timeoutClickShowtimes
{
    [pwdView setCount:0];
    
    pwdTextField.text=@"";
    
    [errorLabel setHidden:YES];
    
    [pwdTextField endEditing:NO];
    
    //[pwdTextField becomeFirstResponder];
    
}

-(void)tapBack:(UIGestureRecognizer *)tap
{
    [pwdTextField resignFirstResponder];
}

// 判断密码输入是否正确
-(void)judgeIStrue:(NSString *)password
{
    //__block BOOL judge;
    // 密码校验
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]PasswordCheckingPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]distributorCode:password];
    NSLog(@"paramDict--->%@",paramDict);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SYMAFNHttp post:SYMPasswordChecking_URL params:paramDict success:^(id responseObj){
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"PasswordCheckingresponseObj-->%@",responsedict);
            if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
                [UIView animateWithDuration:0.3f animations:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [MainImageview removeFromSuperview];
                    MainImageview=nil;
                }];
                if (_backPassword)
                {
                    _backPassword(pwdTextField.text);
                }
            }else{
                errorLabel.text=[NSString stringWithFormat:@"%@",responsedict[@"message"]];
                [errorLabel setHidden:NO];
                [self performSelector:@selector(timeoutClick) withObject:nil afterDelay:1];
                [pwdTextField endEditing:NO];
            }
        } failure:^(NSError *error){
            NSLog(@"error-->%@",error);
            errorLabel.text=[NSString stringWithFormat:@"系统故障"];
            [errorLabel setHidden:NO];
            [self performSelector:@selector(timeoutClick) withObject:nil afterDelay:1];
            [pwdTextField endEditing:NO];
        }];
    });
}


-(void)initTipView :(NSString *)time
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-initTipView-方法");
    
    NSString *haveTime=[NSString stringWithFormat:@"%d",60-[time intValue]];
    
    // NSString *haveTime=time;
    // 超过次数提示
    
    [MainImageview setHidden:YES];
    
    tipview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight, 185*RaiotHeight-50, MainScreenWidth-48*RaiotHeight, MainscreenHeight-185*RaiotHeight-240*RaiotHeight)];
    
    //tipview=[[UIImageView alloc]initWithFrame:CGRectMake(24*RaiotHeight, 185*RaiotHeight, MainScreenWidth-48*RaiotHeight, MainscreenHeight-185*RaiotHeight-240*RaiotHeight)];
    
    tipview.userInteractionEnabled=YES;
    tipview.layer.cornerRadius = 8;
    tipview.layer.masksToBounds = YES;
    
    tipview.image=[UIImage imageNamed:@"send_tips_bg_1"];
    
    [self.view addSubview:tipview];
    
    
    UILabel *textlabel=[[UILabel alloc]initWithFrame:CGRectMake(45*RaiotHeight, 30*RaiotHeight, tipview.bounds.size.width-80*RaiotHeight, 15*RaiotHeight)];
    
    
    textlabel.textAlignment = NSTextAlignmentCenter;
    
    textlabel.text=[NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"textlabel", nil),5,NSLocalizedString(@"please", nil)];// 30分钟后重试
    
    textlabel.font=[UIFont systemFontOfSize:15*RaiotHeight];
    
    textlabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    
    textlabel.numberOfLines=0;
    
    [tipview addSubview:textlabel];
    
    
    // UILabel *textlabelScond=[[UILabel alloc]initWithFrame:CGRectMake(45*RaiotHeight, 60*RaiotHeight, tipview.bounds.size.width-80*RaiotHeight, 30*RaiotHeight)];
    UILabel *textlabelScond=[[UILabel alloc]initWithFrame:CGRectMake(45*RaiotHeight,(textlabel.frame.origin.y+textlabel.bounds.size.height+10*RaiotHeight), tipview.bounds.size.width-80*RaiotHeight, 15*RaiotHeight)];
    
    textlabelScond.textAlignment = NSTextAlignmentCenter;
    
    textlabelScond.textAlignment = NSTextAlignmentCenter;
    
    textlabelScond.text=[NSString stringWithFormat:@"%@分钟后重试",haveTime];
    //NSLocalizedString(@"textlabelScond", nil);
    
    textlabelScond.font=[UIFont systemFontOfSize:15*RaiotHeight];
    
    textlabelScond.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    
    textlabelScond.numberOfLines=0;
    
    [tipview addSubview:textlabelScond];
    
    // 设置分割线
    
    UIImageView *separationLineS=[[UIImageView alloc]initWithFrame:CGRectMake(0,(textlabelScond.frame.origin.y+textlabelScond.bounds.size.height+27*RaiotHeight), tipview.bounds.size.width, 1*RaiotHeight)];
    
    separationLineS.image=[UIImage imageNamed:@"send_enterPassword_drive"];
    
    [tipview addSubview:separationLineS];
    
    
    // 设置确定按钮
    UIButton *determineButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    determineButton.frame=CGRectMake(119*RaiotHeight,(separationLineS.frame.origin.y+separationLineS.bounds.size.height+15*RaiotHeight), tipview.bounds.size.width-238*RaiotHeight, 17*RaiotHeight);
    
    determineButton.titleLabel.font=[UIFont systemFontOfSize:15*RaiotHeight];
    
    [determineButton setTitle:NSLocalizedString(@"determineButton", nil) forState:UIControlStateNormal];
    
    [determineButton setTitleColor:[UIColor colorWithRed:14/255.0f green:118/255.0f blue:168/255.0f alpha:1] forState:UIControlStateNormal];
    
    //[determineButton setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1] forState:UIControlStateSelected];
    
    [determineButton addTarget:self action:@selector(TipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [tipview addSubview:determineButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    //[tabcontrol hidenTabBar:YES];
    
    [self changePintype];
    [errorLabel setHidden:YES];
    
    if (self.isinput==isInviteCode || self.isinput==isHelpCard || self.isinput==isTransactionrecords) {
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.5;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [self.view.layer addAnimation:animation forKey:nil];
    }
}

// 点击超过次数按钮
static bool isresult=YES;
-(void)TipButtonClick:(UIButton *)button
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-TipButtonClick-方法");
    
    [MainImageview setHidden:YES];
    
    [tipview setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (isresult) {
        
        isresult=NO;
    }
}

-(void)unlockClick
{
    NSLog(@"调用了BtmSharePinPassWordViewController中的-unlockClick-方法");
    
    manyTimes=3;
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    // BTMUserInfo *userinfo=(BTMUserInfo *)[BTMUserInfo defaultUserInfo];
    // [userinfo.tabarcontroller setHidesBottomBarWhenPushed:YES];
    // BTTabController *tabar=(BTTabController *)userinfo.tabarcontroller;
    // [tabar hidenTabBar:NO];
    isaway=YES;
    if (manyTimes>0)
    {
        NSUserDefaults *defaultTimes=[[NSUserDefaults alloc]init];
        [defaultTimes setObject:[NSNumber numberWithInt:manyTimes] forKey:@"changtime"];
        [defaultTimes setObject:[NSNumber numberWithBool:YES] forKey:@"isaway"];
        [defaultTimes synchronize];
    }
}




// 计算时间差值

//-(NSString *) compareCurrentTime:(NSDate*) compareDate
//{
//    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
//    timeInterval = -timeInterval;
//    long temp = 0;
//    NSString *result;
//    if (timeInterval < 60) {
//        result = [NSString stringWithFormat:@"刚刚"];
//
//    }
//    else if((temp = timeInterval/60) <60){
//        result = [NSString stringWithFormat:@"%ld分前",temp];
//    }
//
//    else if((temp = temp/60) <24){
//        result = [NSString stringWithFormat:@"%ld小前",temp];
//    }
//
//    else if((temp = temp/24) <30){
//        result = [NSString stringWithFormat:@"%ld天前",temp];
//    }
//
//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",temp];
//    }
//
//    return  result;
//}

-(void)getFingerFiaction
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Restricted Area!";
    
    // myContext.localizedFallbackTitle=@"";  // Enter Password 按钮被隐藏
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {// 验证设备是否可以进行指纹验证
        
        //进行指纹识别
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        alert.title = @"Success";
                                        alert.message = @"You have access to private content!";
                                        [alert show];
                                        
                                        if (_backPassword)
                                        {
                                            _backPassword([self findIdfa]);
                                        }
                                        
                                        if (_requestback)
                                        {
                                            //     _requestback([self findIdfa],[[KeyHandle defautKey] checkSeedByScriptSeed:[[NSUserDefaults standardUserDefaults]objectForKey:BTMSIGNED_SEED] Password:[self findIdfa]]);
                                        }
                                        
                                    });
                                    
                                }
                                else
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        // 没有开启Touch ID 功能
                                        
                                        // [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UseTouchID];
                                        // [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        alert.title = @"Fail";
                                        
                                        switch (error.code) {
                                            case LAErrorUserCancel:
                                                
                                                //                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UseTouchID];
                                                //                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                //认证被用户取消.例如点击了 cancel 按钮.
                                                
                                                alert.message = @"Authentication Cancelled";
                                                break;
                                                
                                            case LAErrorAuthenticationFailed:
                                                // 认证没有成功,因为用户没有成功的提供一个有效的认证资格
                                                alert.message = @"Authentication Failed";
                                                break;
                                                
                                            case LAErrorPasscodeNotSet:
                                                //认证不能开始,因为此台设备没有设置密码.
                                                alert.message = @"Passcode is not set";
                                                break;
                                                
                                            case LAErrorSystemCancel:
                                                // 认证被系统取消了(例如其他的应用程序到前台了)
                                                alert.message = @"System cancelled authentication";
                                                break;
                                                
                                            case LAErrorUserFallback:
                                                // 认证被取消,因为用户点击了 fallback 按钮(输入密码).
                                                alert.message = @"You chosed to try password";
                                                break;
                                                
                                            default:
                                                alert.message = @"You cannot access to private content!";
                                                break;
                                        }
                                        
                                        [alert show];
                                        
                                    });
                                    
                                }
                            }];
        
    }
    else
    {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UseTouchID];
            // [[NSUserDefaults standardUserDefaults] synchronize];
            
            alert.title = @"Warning";
            
            if(authError.code == LAErrorTouchIDNotEnrolled) {
                // 认证不能开始,因为 touch id 没有录入指纹.
                alert.message = @"You do not have any fingerprints enrolled!";
            }else if(authError.code == LAErrorTouchIDNotAvailable) {
                alert.message = @"Your device does not support TouchID authentication!";
            }else if(authError.code == LAErrorPasscodeNotSet){
                alert.message = @"Your passcode has not been set";
            }
            
            [alert show];
            
        });
    }
}

#pragma mark - 获取Idfa
-(NSString *)findIdfa
{
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    return idfa;
}

#pragma mark- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIButton *button=(UIButton *)button;
    [self dismissViewControllerAnimated:YES completion:nil];
    [MainImageview removeFromSuperview];
    MainImageview=nil;
}


#pragma mark- 获取过期时间
-(void)getTimeOUt
{
    
    //    [XNQAFNHttp getNew:[NSString stringWithFormat:@"%@",BTMGETTIME_URL] params:nil success:^(id responseObj) {
    //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
    //        NSLog(@"dict--->%@",dict);
    //
    //        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"OutTimeS"]) {
    //
    //            [[NSUserDefaults standardUserDefaults]setObject:dict[@"timestamp"] forKey:@"OutTimeS"];
    //            [[NSUserDefaults standardUserDefaults]synchronize];
    //        }
    //
    //    } failure:^(NSError *error) {
    //
    //        NSLog(@"%@",error);
    //    }];
    
}


#pragma mark ----计算时间差
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    // 时间戳转成时间
    NSString *parmtime=  [self getNowDate:theDate];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d=[date dateFromString:parmtime];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"0";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        
        NSLog(@"========================================计算时间");
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        //timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    
    
    //            if (cha/3600>1&&cha/86400<1) {
    //                timeString = [NSString stringWithFormat:@"%f", cha/3600];
    //                timeString = [timeString substringToIndex:timeString.length-7];
    //               // timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    //            }
    
    
    //    if (cha/86400>1)
    //    {
    //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        // timeString=[NSString stringWithFormat:@"%@天前", timeString];
    //
    //    }5876.62047290802
    
    //[date release];
    NSLog(@"多少天后=%@",timeString);
    return timeString;
}

-(NSString *)getNowDate:(NSString *)nowdate
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT"]; // Asia/Shanghai
    //    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[nowdate intValue]];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    
    return confromTimespStr;
}

-(void)changePintype
{
    switch (self.isinput) {
        case 0:
            // 发送BTC
            [self initViewcontrols];
            [self setControlsInMainImageview];
            break;
        case 1:
            
            //设置密码
            [self initLoginViewcontrols];
            [self setLoginPINControlsInMainImageview];
            break;
        case 2:
            
            // 输入密码
            [self initInputViewcontrols];
            [self setInputPINControlsInMainImageview];
            break;
        case 3:
            // 调用touch id
            // [self getFingerFiaction];
            break;
        case 4:
            
            // 未实名认证的
            [self initViewcontrolsNorealname];
            [self setNotReslNameControlsInMainImageview];
            break;
        case 5:
            
            // 邀请码
            [self initInviteCodeViewcontrols];
            [self setInviteCodeControlsInMainImageview];
            break;
            case 6:
            // 未帮卡
            [self initHelpCardViewcontrols];
            [self setHelpCardControlsInMainImageview];
            break;
            case 7:
            // 交易记录提示
            [self initTransactionViewcontrols];
            [self setTransactionControlsInMainImageview];
            break;
        default:
            break;
    }
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

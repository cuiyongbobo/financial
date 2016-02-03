//
//  RegularProductDetailsViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "RegularProductDetailsViewController.h"
#import "SYMConstantCenter.h"
#import "ProductDetailsTableViewCell.h"
#import "ProductDetailsMoreTableViewCell.h"
#import "SYMTabController.h"
#import "SYMSupportBankViewController.h"
#import "SYMTiedCardViewController.h"
#import "SYMPersonalMoreCell.h"
#import "SYMAddProductDetailsewController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "MJRefresh.h"
#import "SYMSecurityWebViewController.h"
#import "SYMDataBaseModel.h"
#import "LoginViewController.h"
#import "DailyInterestProductDetailsViewController.h"
#import "SYMInformationSave.h"
#import "BtmSharePinPassWordViewController.h"
#import "SYMBackpayPasswordViewController.h"
#import "MyTipsWindow.h"
#import "SharePlatform.h"
#import "UIImageView+WebCache.h"

@interface RegularProductDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *informationDataArraySection;
    NSMutableArray *informationDataArraySectiones;
    UIProgressView *progressView;
    NSTimer *timerS;
    double progressValues;
    double movedistance;
    double saveProgressValues;
    NSMutableArray *_dataArray;
    NSString *startAccrualDate;
    NSString *endAccrualDate;
    double expectedBenefit;
    NSMutableArray *_dataArrayMore;
    SharePlatform *share;
}
@end

@implementation RegularProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationView];
    _dataArray=[[NSMutableArray alloc]init];
    _dataArrayMore=[[NSMutableArray alloc]init];
    informationDataArraySection=[[NSMutableArray alloc]init];
    informationDataArraySectiones=[[NSMutableArray alloc]init];
    self.ProductDetailsTableView.tableFooterView=[[UIView alloc]init];
    [self customtoolBar];
    [self.ContinueCast pointInside:CGPointMake(300, 300) withEvent:nil];
    [self.redemption pointInside:CGPointMake(300, 300) withEvent:nil];
    [self.ProductDetailsTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(doHeaderRefresh)];
    [self.InputInvestment addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}


-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"产品详情";
    
    //  定义Navigation 的左右按钮
    UIButton *Leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    Leftbutton.frame=CGRectMake(0, 0, 23/2*SYMWIDthRATESCALE, 41/2*SYMHEIGHTRATESCALE);
    Leftbutton.tag=300;
    [Leftbutton setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [Leftbutton addTarget:self action:@selector(LeftandRightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft=[[UIBarButtonItem alloc]initWithCustomView:Leftbutton];
    self.navigationItem.leftBarButtonItem=itemLeft;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 45/2*SYMWIDthRATESCALE, 11/2*SYMHEIGHTRATESCALE);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_fenxiang"] forState:UIControlStateNormal];
    rightButton.tag=301;
    [rightButton addTarget:self action:@selector(LeftandRightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemRight=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=itemRight;
    
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:SYMFontColor];
    [_TitleImage addSubview:companyAccount];
}

-(void)LeftandRightClick:(UIButton *)button{
    if (button.tag==300) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (button.tag==301){
        NSLog(@"分享操作");
        [self determineUserIslogin];
    }
}



#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 4;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    switch (indexPat.section) {
            
        case 0:
        {
            static NSString *Identity=@"cell";
            ProductDetailsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
            
            if (cell==nil) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"ProductDetailsTableViewCell" owner:self options:nil] lastObject];
            }
            if (_dataArray.count!=0) {
                ProductDetails *detailModel=_dataArray[0];
                cell.SaleTotalBalance.text=[NSString stringWithFormat:@"%@.00",detailModel.amount];
                cell.remainingTotalBalance.text=[NSString stringWithFormat:@"%.2f",[detailModel.amount doubleValue]-[detailModel.seld doubleValue]];
                NSLog(@"[detailModel.seld doubleValue]=%f",([detailModel.seld doubleValue])/([detailModel.amount doubleValue]));
                
                cell.ProgressPercentage.text=[NSString stringWithFormat:@"%.2f",([detailModel.seld doubleValue]/[detailModel.amount doubleValue])*100];
                
                NSString *unitcalculate=[self matchLimtTime:[NSString stringWithFormat:@"%@",detailModel.unit]];
                // 计算预计收益公式
                double calculateEarning=[self.StandardEarning.text doubleValue]+[self.additionalEarning.text doubleValue];
                //10000*6*0.6/（100*12）   投资金额*理财期限*年化收益率/100*理财单位
                expectedBenefit=10000*[detailModel.period doubleValue]*calculateEarning/(100*[unitcalculate intValue]);
                
                // 收益
                // 分销收益-已经加上扩展收益了
                double Calculatetotal=[[NSString stringWithFormat:@"%@",detailModel.expandProfit] doubleValue];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:ISdistribution] isEqualToString:@"1"]) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
                }else{
                    // 新老用户
                    NSString *usertypeinfor=[[NSUserDefaults standardUserDefaults]objectForKey:UserType];
                    BOOL isc=[[SYMPublicDictionary shareDictionary]judgeString:usertypeinfor];
                    if (!isc) {
                        if ([usertypeinfor isEqualToString:[NSString stringWithFormat:@"%@",detailModel.purchaserType]]) {
                            Calculatetotal+=[[NSString stringWithFormat:@"%@",detailModel.purchaserProfit] doubleValue];
                        }
                    }
                }
                
                NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
                // 终端收益
                BOOL c=[[SYMPublicDictionary shareDictionary]judgeString:userId];
                if (c) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",detailModel.terminalProfit] doubleValue];
                }
                
                if (Calculatetotal==0) {
                    // 隐藏
                    [self.BDAddImageview setHidden:YES];
                    self.Leftwidth.constant=17*SYMWIDthRATESCALE;
                    [self.additionalEarning setHidden:YES];
                    [self.addlabel setHidden:YES];
                    self.rightwidth.constant=100*SYMWIDthRATESCALE;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.ProductName.text=[NSString stringWithFormat:@"%@",detailModel.productName];
                    self.Labelone.text=[NSString stringWithFormat:@"%@",detailModel.label1];
                    self.LabeSecond.text=[NSString stringWithFormat:@"%@",detailModel.Label2];
                    self.LabeThird.text=[NSString stringWithFormat:@"%@",detailModel.Label3];
                    self.StandardEarning.text=[NSString stringWithFormat:@"%@",detailModel.standardProfit];
                    self.additionalEarning.text=[NSString stringWithFormat:@"%.2f",Calculatetotal];
                });
            }
            progressValues=[cell.ProgressPercentage.text doubleValue]/100;
            progressView=cell.DetailProgress;
            if (saveProgressValues>0) {
                progressView.progress=saveProgressValues;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        case 1:
        {
            if (indexPat.row==3) {
                static NSString *formalIdentity=@"cell";
                SYMPersonalMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:formalIdentity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMPersonalMoreCell" owner:self options:nil]lastObject];
                }
                [cell.PhoneNumber setHidden:YES];
                cell.InformationLabel.text=@"更多详情";
                cell.InformationLabel.font=[UIFont systemFontOfSize:12.0];
                cell.InformationLabel.textColor=SYMFontblackColor;
                cell.ArrowImageView.image=[UIImage imageNamed:@"enter_arrow.png"];
                return cell;
            }else{
                static NSString *formalIdentity=@"cell";
                ProductDetailsMoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:formalIdentity];
                if (cell==nil) {
                    cell=[[[NSBundle mainBundle]loadNibNamed:@"ProductDetailsMoreTableViewCell" owner:self options:nil]lastObject];
                }
                if (indexPat.row==1) {
                    if (_dataArray.count!=0) {
                        ProductDetails *detailModel=_dataArray[0];
                        cell.Unit.text=[NSString stringWithFormat:@"%@",detailModel.startAccrualDate];
                    }else{
                        cell.Unit.text=[NSString stringWithFormat:@""];
                    }
                    
                    [cell.WanBenefit setHidden:YES];
                    [cell.BenefitMoney setHidden:YES];
                    cell.ExpectedEarnings.text=@"起息时间";
                    
                    
                }else if (indexPat.row==2){
                    if (_dataArray.count!=0) {
                        ProductDetails *detailModel=_dataArray[0];
                        cell.Unit.text=[NSString stringWithFormat:@"%@",detailModel.endAccrualDate];
                    }else{
                        cell.Unit.text=[NSString stringWithFormat:@""];
                    }
                    [cell.WanBenefit setHidden:YES];
                    [cell.BenefitMoney setHidden:YES];
                    cell.ExpectedEarnings.text=@"结息时间";
                    
                }else if (indexPat.row==0){
                    //cell.Unit.text=@"元";
                    cell.BenefitMoney.text=[NSString stringWithFormat:@"%.2f",expectedBenefit];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (indexPath.row==3) {
                if (_dataArray.count!=0) {
                    ProductDetails *detailsModel=_dataArray[0];
                    SYMAddProductDetailsewController *detail=[[SYMAddProductDetailsewController alloc]initWithNibName:@"SYMAddProductDetailsewController" bundle:nil];
                    detail.model=detailsModel;
                    detail.startTimer=detailsModel.startAccrualDate;
                    detail.endTiner=detailsModel.endAccrualDate;
                    [self.navigationController pushViewController:detail animated:YES];
                }else{
                    return;
                }
            }
        }
            break;
        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 95*SYMHEIGHTRATESCALE;
    }else if (indexPath.section==1){
        return 60*SYMHEIGHTRATESCALE;
    }else{
        return 0;
    }
}

// tableview 的section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else if (section==1){
        return 10;
    }else{
        return 0;
    }
}

//自定义section的头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UIView *headerView = [[UIView alloc] init];
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=SYMBDClolor;
    headerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 10);//创建一个视图
    return headerView;
}

/*进度条每次加0.01 */
-(void) timerChanged:(id)sender
{
    if (progressView.progress>=progressValues) {
        saveProgressValues=progressView.progress;
        [timerS invalidate];
        timerS=nil;
        
    }else{
        progressView.progress +=0.01f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    // 请求产品详情接口
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self requestProductDetails];
    });
    
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    [self.promptDetailBD setHidden:YES];
    self.ContinueCast.selected=YES;
    self.redemption.selected=NO;
    timerS=[NSTimer scheduledTimerWithTimeInterval:0.03f
                                            target:self
                                          selector:@selector(timerChanged:)
                                          userInfo:nil
                                           repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop]addTimer:timerS forMode:NSRunLoopCommonModes];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
    
    self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
    [self.InputInvestment resignFirstResponder];
    [self.promptDetailBD setHidden:YES];
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
    if ([UIScreen mainScreen].bounds.size.height-(self.InputInvestment.frame.origin.y+self.InputInvestment.frame.size.height)<height) {
        
        CGFloat Lowhight=height-([UIScreen mainScreen].bounds.size.height-(self.InputInvestment.frame.origin.y+self.InputInvestment.frame.size.height));
        NSLog(@"屏幕高度--->%f",Lowhight);
        [UIView animateWithDuration:0.3f animations:^{
            self.navigationController.view.transform=CGAffineTransformMakeTranslation(0, -Lowhight-65);
            movedistance=-Lowhight-70;
        }];
    }
    [self.promptDetailBD setHidden:NO];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}

-(void)customtoolBar{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, BTMWidth, 30)];
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    //[btn setTitleColor:SYMBLUECOLOR];
    [btn setTitleColor:SYMBLUECOLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.InputInvestment  setInputAccessoryView:topView];
}

-(void)dismissKeyBoard:(UIButton *)button{
    
    NSLog(@"点击完成按钮");
    [UIView  animateWithDuration:0.3f animations:^{
        self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
        [self.InputInvestment resignFirstResponder];
        [self.promptDetailBD setHidden:YES];
    }];
}

-(IBAction)switchstate:(id)sender{
    UIButton *button=(UIButton *)sender;
    if (button.tag==400) {
        // 续投
        self.ContinueCast.selected=YES;
        self.redemption.selected=NO;
        self.status=@"1";
        
    }else if (button.tag==401){
        // 赎回
        self.ContinueCast.selected=NO;
        self.redemption.selected=YES;
        self.status=@"0";
    }
    
    [SYMInformationSave defaultSaveInformation].isstate=self.status;
    NSLog(@"=%@",[SYMInformationSave defaultSaveInformation].isstate);
}

- (IBAction)depositClick:(id)sender {
    NSLog(@"xutou=%@",[SYMInformationSave defaultSaveInformation].isstate);
    BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:self.InputInvestment.text];
    if (!b) {
        if (_dataArray.count!=0) {
            ProductDetails *detailModel=_dataArray[0];
            NSString *minInvest=detailModel.minInvest;
            NSString *maxInvest=detailModel.maxInvest;
            NSString *raiseInvest=detailModel.raiseInvest;
            NSString *remaining=detailModel.remaining;
            
            if ([self.InputInvestment.text intValue]<[minInvest intValue]) {
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"买入金额不能小于%@",minInvest] backgroundcolor:white];
            }else{
                NSLog(@"--->%d",[self.InputInvestment.text intValue]%[raiseInvest intValue]);
                if (!([self.InputInvestment.text intValue]%[raiseInvest intValue]==0)) {
                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"买入金额必须为%@的整数倍",raiseInvest] backgroundcolor:white];
                }else{
                    // 正常的
                    if ([remaining intValue]<[maxInvest intValue]) {
                        if ([self.InputInvestment.text intValue]<=[remaining intValue]) {
                            // 正常
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
                                [self.InputInvestment resignFirstResponder];
                                [self.promptDetailBD setHidden:YES];
                            });
                            
                            // 请求开户接口
                            NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
                            BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:userId];
                            if (!b) { // 正常应该是!b
                                // 登录成功
                                [self requestOpenAcconut:userId];
                            }else{
                                // 去登陆
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    // 测试登录
                                    LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                                    [self.navigationController pushViewController:login animated:YES];
                                    login.backLogin=^{
                                        // 登录成功
                                        [self requestOpenAcconut:[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN]];
                                    };
                                });
                            }
                            
                        }else{
                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"不能大于%@",remaining] backgroundcolor:white];
                        }
                        
                    }else{
                        if ([self.InputInvestment.text intValue]<=[maxInvest intValue]) {
                            // 正常
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
                                [self.InputInvestment resignFirstResponder];
                                [self.promptDetailBD setHidden:YES];
                            });
                            
                            // 请求开户接口
                            NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
                            BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:userId];
                            if (!b) { // 正常应该是!b
                                // 登录成功
                                [self requestOpenAcconut:userId];
                            }else{
                                // 去登陆
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    // 测试登录
                                    LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                                    [self.navigationController pushViewController:login animated:YES];
                                    login.backLogin=^{
                                        // 登录成功
                                        [self requestOpenAcconut:[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN]];
                                    };
                                });
                            }
                            
                        }else{
                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:[NSString stringWithFormat:@"不能大于%@",maxInvest] backgroundcolor:white];
                        }
                    }
                }
            }
        }
        
    }else{
        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请输入购买金额" backgroundcolor:white];
        NSLog(@"请输入购买金额");
    }
}

#pragma mark- 请求商品详情接口
-(void)requestProductDetails{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]ProductDetailsPublicDictnary:self.productModel.productCode PurchaserType:0 productCatCode:self.productModel.productCatCode];
    [SYMAFNHttp post:SYMProductDetails_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObjProductDetails-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                NSMutableDictionary *dict=responsedict[@"data"];
                ProductDetails *detailModel=[[ProductDetails alloc]init];
                detailModel.productCode=dict[@"productCode"];
                detailModel.productName=dict[@"productName"];
                detailModel.standardProfit=dict[@"standardProfit"];
                detailModel.expandProfit=dict[@"expandProfit"];
                detailModel.amount=dict[@"amount"];
                detailModel.seld=dict[@"seld"];
                detailModel.label1=dict[@"label1"];
                detailModel.Label2=dict[@"label2"];
                detailModel.Label3=dict[@"label3"];
                detailModel.unit=dict[@"unit"];
                detailModel.period=dict[@"period"];
                detailModel.minInvest=dict[@"minInvest"];
                detailModel.raiseInvest=dict[@"raiseInvest"];
                detailModel.defaultExpireProcessMode=dict[@"defaultExpireProcessMode"];
                detailModel.rate=dict[@"rate"];
                detailModel.riskLevel=dict[@"riskLevel"];
                detailModel.distributorCode=dict[@"distributorCode"];
                detailModel.terminalProfit=dict[@"terminalProfit"];
                detailModel.purchaserProfit=dict[@"purchaserProfit"];
                detailModel.purchaserType=dict[@"purchaserType"];
                detailModel.isdistribute=dict[@"isDistribute"];
                detailModel.startAccrualDate=dict[@"startAccrualDate"];
                detailModel.endAccrualDate=dict[@"endAccrualDate"];
                detailModel.maxInvest=dict[@"maxInvest"];
                detailModel.remaining=dict[@"remaining"];
                detailModel.continuedInvestmentStatus=dict[@"continuedInvestmentStatus"];
                detailModel.productCatCode=dict[@"productCatCode"];
                [_dataArray addObject:detailModel];
                
                if (_dataArray.count!=0) {
                    ProductDetails *detailModel=_dataArray[0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.InputInvestment.placeholder=[NSString stringWithFormat:@"%@元起投",detailModel.minInvest];
                        if ([[NSString stringWithFormat:@"%@",detailModel.continuedInvestmentStatus] isEqualToString:@"0"]) {
                            // 隐藏控件
                            [self.TitleInformation setHidden:YES];
                            [self.xutoubutton setHidden:YES];
                            [self.xutouLabel setHidden:YES];
                            [self.shuhuibutton setHidden:YES];
                            [self.shuhuiLabel setHidden:YES];
                        }else{
                            // 设置默认续投状态
                            [SYMInformationSave defaultSaveInformation].isstate=@"1";
                        }
                    });
                }
            });
            [self.ProductDetailsTableView reloadData];
            // 结束刷新
            [self.ProductDetailsTableView.header endRefreshing];
            
        }else{
            // 结束刷新
            [self.ProductDetailsTableView.header endRefreshing];
            return;
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 刷新操作
-(void)doHeaderRefresh//刷新
{
    if (_dataArray.count!=0) {
        [_dataArray removeAllObjects];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [self requestProductDetails];
    });
}

#pragma mark- 匹配日期
-(NSString *)matchLimtTime:(NSString *)unit{
    
    NSString *limitTim=@"无";
    if ([unit isEqualToString:@"Y"]) {
        limitTim=@"1";
    }else if ([unit isEqualToString:@"M"]){
        limitTim=@"12";
        
    }else if ([unit isEqualToString:@"D"]){
        limitTim=@"365";
    }
    return limitTim;
}

#pragma mark- 输入框随动
- (void)textFieldEditChanged:(UITextField *)textField
{
    NSLog(@"textField=%@",textField.text);
    if ([textField.text intValue]>100) {
        NSLog(@"已经大于100");
        self.matures.text=[NSString stringWithFormat:@"%.2f",expectedBenefit/10000*[textField.text intValue]];
    }else{
        self.matures.text=@"0.00";
    }
}

#pragma mark-开户接口
-(void)requestOpenAcconut:(NSString *)userId
{
    if (_dataArray.count!=0) {
        ProductDetails *detailModel=_dataArray[0];
        [SYMInformationSave defaultSaveInformation].detailModel=detailModel;
        NSMutableDictionary *paramDict=[[SYMPublicDictionary shareDictionary]OpenAccountPublicDictnary:userId distributorCode:detailModel.distributorCode];
        NSLog(@"paramDict=%@",paramDict);
        [SYMAFNHttp post:SYMOpenAccountCard_URL params:paramDict success:^(id responseObj){
            NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"responseInterest-->%@",responsedict);
            if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSDictionary *dict=responsedict[@"data"];
                    OpenAccount *model=[[OpenAccount alloc]init];
                    model.bankCode=dict[@"bankCode"];
                    model.bankName=dict[@"bankName"];
                    model.buyMode=dict[@"buyMode"];
                    model.cardNo=dict[@"cardNo"];
                    model.contractNo=dict[@"contractNo"];
                    model.custNo=dict[@"custNo"];
                    model.distributorCode=dict[@"distributorCode"];
                    model.idCardNo=dict[@"idCardNo"];
                    model.investorName=dict[@"investorName"];
                    model.isCashPwd=dict[@"isCashPwd"];
                    model.isDefault=dict[@"isDefault"];
                    model.isNote=dict[@"isNote"];
                    model.isReal=dict[@"isReal"];
                    model.isopenacct=dict[@"isopenacct"];
                    model.memo=dict[@"memo"];
                    model.mobilePhone=dict[@"mobilePhone"];
                    model.papersType=dict[@"papersType"];
                    model.payMode=dict[@"payMode"];
                    model.tradeId=dict[@"tradeId"];
                    model.userId=dict[@"userId"];
                    // 业务逻辑
                    [self businessLogic:model];
                });
            }
        } failure:^(NSError *error){
            NSLog(@"error-->%@",error);
        }];
    }
}

#pragma mark- 业务逻辑流程
-(void)businessLogic:(OpenAccount *)model{
    
    if (![[NSString stringWithFormat:@"%@",model.isopenacct] isEqualToString:@"0"]) { // !
        [[NSUserDefaults standardUserDefaults]setObject:@"ok" forKey:SETPasswordStatus];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
        [self.InputInvestment resignFirstResponder];
        [self.promptDetailBD setHidden:YES];
        // 截取字符串
        NSLog(@"len=%lu",(unsigned long)model.cardNo.length);
        NSString *cardNo=[model.cardNo substringFromIndex:model.cardNo.length-4];
        NSLog(@"cardNO=%@",cardNo);
        // 开过户了
        // 实名认证的支付密码
        BtmSharePinPassWordViewController *PinPasswordVC=[[BtmSharePinPassWordViewController alloc]initWithNibName:@"BtmSharePinPassWordViewController" bundle:nil];
        PinPasswordVC.isinput=isSendBTC;
        PinPasswordVC.sendmoney=self.InputInvestment.text;
        PinPasswordVC.bankName=[NSString stringWithFormat:@"使用%@",model.bankName];
        PinPasswordVC.cardNo=[NSString stringWithFormat:@"%@",cardNo];
        PinPasswordVC.memo=model.memo;
        [PinPasswordVC defaultStandPinPassword:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:PinPasswordVC animated:NO completion:nil];
        });
        
        PinPasswordVC.close=^{
            self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
            [self.InputInvestment resignFirstResponder];
            [self.promptDetailBD setHidden:YES];
        };
        PinPasswordVC.backPassword = ^(NSString *password)
        {
            self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
            [self.InputInvestment resignFirstResponder];
            [self.promptDetailBD setHidden:YES];
            NSLog(@"密码框回调");
            // 进行付款操作
            [self BuyTheProduct:model];
        };
        
        PinPasswordVC.forgetpassword=^{
            dispatch_async(dispatch_get_main_queue(), ^{
                SYMBackpayPasswordViewController *backpaypassword=[[SYMBackpayPasswordViewController alloc]initWithNibName:@"SYMBackpayPasswordViewController" bundle:nil];
                [self.navigationController pushViewController:backpaypassword animated:YES];
            });
        };
        
    }else {
        // 没有开户
        dispatch_async(dispatch_get_main_queue(), ^{
            SYMTiedCardViewController *tiedCard=[[SYMTiedCardViewController alloc]initWithNibName:@"SYMTiedCardViewController" bundle:nil];
            if (_dataArray.count!=0) {
                ProductDetails *detailModel=_dataArray[0];
                tiedCard.detailModel=detailModel;
            }
            tiedCard.acconutmodel=model;
            tiedCard.Tiedstatus=[SYMInformationSave defaultSaveInformation].isstate; // 投入状态
            tiedCard.InvestmentAmount=self.InputInvestment.text; // 投入金额
            [self.navigationController pushViewController:tiedCard animated:YES];
        });
    }
}

#pragma mark- 购买接口
-(void)BuyTheProduct:(OpenAccount *)model
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    ProductDetails *modeldetail=[SYMInformationSave defaultSaveInformation].detailModel;
    paramDict=[[SYMPublicDictionary shareDictionary]PayProductPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] distributorCode:model.distributorCode isIndividual:@"0" productCode:modeldetail.productCode amount:self.InputInvestment.text investorName:model.investorName certType:@"0" idCardNo:model.idCardNo bankCode:model.bankCode bankName:model.bankName cardNo:model.cardNo mobilePhone:model.mobilePhone buyMode:model.buyMode custNo:model.custNo isInvestAgain:[SYMInformationSave defaultSaveInformation].isstate payMode:model.payMode invitecode:@"" reserve1:@"1" reserve2:@"1" reserve3:@"" reserve4:@"1" reserve5:@"" orderNo:@""];
    NSLog(@"BuyTheProductparamDict--->%@",paramDict);
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

#pragma mark- 判断用户是否登录
-(void)determineUserIslogin
{
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
    BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:userId];
    if (!b) {
        // 登录成功
        if (_dataArray.count!=0) {
            // 截取手机号后4位
            NSString *iPhoneNumber=[[NSUserDefaults standardUserDefaults]objectForKey:IPhonenumber];
            NSString *realnumber=[iPhoneNumber substringFromIndex:iPhoneNumber.length-8];
            ProductDetails *detailModel=_dataArray[0];
            [self getURLJumppage:detailModel.productCode productCatCode:detailModel.productCatCode invitationCode:realnumber];
        }
        
    }else{
        // 去登陆
        dispatch_async(dispatch_get_main_queue(), ^{
            // 测试登录
            LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:login animated:YES];
            login.backLogin=^{
                // 登录成功
                if (_dataArray.count!=0) {
                    // 截取手机号后4位
                    NSString *iPhoneNumber=[[NSUserDefaults standardUserDefaults]objectForKey:IPhonenumber];
                    NSString *realnumber=[iPhoneNumber substringFromIndex:iPhoneNumber.length-4];
                    ProductDetails *detailModel=_dataArray[0];
                    [self getURLJumppage:detailModel.productCode productCatCode:detailModel.productCatCode invitationCode:realnumber];
                }
                
            };
        });
    }
}

#pragma mark- 获取url
-(void)getURLJumppage:(NSString *)productCode productCatCode:(NSString *)productCatCode invitationCode:(NSString *)invitationCode
{
    
    NSString *longurl=[[NSString stringWithFormat:@"http://123.57.248.253/webapp/share/toLandingPage?productCode=%@&productCatCode=%@&invitationCode=%@",productCode,productCatCode,invitationCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]ShareUrlbackPublicDictnary:[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN] longUrl:longurl];
    NSLog(@"ShareUrlparamDict--->%@",paramDict);
    [SYMAFNHttp post:SYMShareback_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ShareUrlresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSString *shorturl=responsedict[@"data"]; // 短连接
            // 拼接短连接
            NSString *longUrl=[NSString stringWithFormat:@"http://123.57.248.253/share/%@",shorturl];
            NSLog(@"shorturl=%@",longUrl);
            // 分享功能
            share=[[SharePlatform alloc]init];
            share.qrAddress=@"邀请好友一起投资，双双享有原收益+0.5%，还有1%佣金等...";
            share.backUrl=longUrl;
            [share initShare];
            [share showShare:self];
            
        }else{
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:responsedict[@"message"] backgroundcolor:white];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
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

//
//  RegularProductDetailsViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/16.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "DailyInterestProductDetailsViewController.h"
#import "SYMConstantCenter.h"
#import "ProductDetailsTableViewCell.h"
#import "ProductDetailsMoreTableViewCell.h"
#import "SYMTabController.h"
#import "SYMSupportBankViewController.h"
#import "DailyInterestTreasureTableViewCell.h"
#import "SYMPersonalMoreCell.h"

@interface DailyInterestProductDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    UISlider *_mySlider;
    UIImageView *tipBD;
    UILabel *_depositMoney;
}
@end

@implementation DailyInterestProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    informationDataArraySection=[[NSMutableArray alloc]init];
    informationDataArraySectiones=[[NSMutableArray alloc]init];
    self.ProductDetailsTableView.tableFooterView=[[UIView alloc]init];
    //    [self.view removeGestureRecognizer:self.myTap];
    self.InputInvestment.delegate=self;
    [self customtoolBar];
    [self.ContinueCast pointInside:CGPointMake(300, 300) withEvent:nil];
    [self.redemption pointInside:CGPointMake(300, 300) withEvent:nil];
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
    }
}



#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if (indexPat.row==0) {
        
        static NSString *Identity=@"cell";
        DailyInterestTreasureTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
        
        if (cell==nil) {
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"DailyInterestTreasureTableViewCell" owner:self options:nil] lastObject];
        }
        _depositMoney=cell.depositMoney;
        _mySlider=cell.mySlider;
        tipBD=cell.ShowProgress;
        _mySlider.minimumValue = 0.0f;//滑动条的最小值
        _mySlider.maximumValue = 100.0f;//滑动条的最大值
        _mySlider.value =0;//滑动条的当前值
        _mySlider.continuous = YES;//设置只有在离开滑动条的最后时刻才触发滑动事件
        //[_mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEventValueChanged];
        [_mySlider addTarget:self action:@selector(clickSlider:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
        
    }else if(indexPat.row==1){
        static NSString *IdentityMore=@"cell";
        SYMPersonalMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:IdentityMore];
        
        if (cell==nil) {
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMPersonalMoreCell" owner:self options:nil] lastObject];
        }
        
        cell.InformationLabel.text=@"更多详情";
        cell.InformationLabel.font=[UIFont systemFontOfSize:13];
        cell.ArrowImageView.image=[UIImage imageNamed:@"enter_arrow"];
        
        
        return cell;
        
    }else{
        return nil;
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
            
        }
            break;
        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 197*SYMHEIGHTRATESCALE;
    }else{
        return 48*SYMHEIGHTRATESCALE;
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

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0;
//}


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
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
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
    //[self.promptDetailBD setHidden:NO];
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
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
    //       // self.BTMScrollview.contentOffset = CGPointMake(0,0);
    //       // self.view.transform=CGAffineTransformMakeTranslation(0, -Lowhight+13);
    //
    //    }];
    
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
        //self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
//        self.ProductDetailsTableView.transform=CGAffineTransformMakeTranslation(0,0);
//        [self.InputInvestment resignFirstResponder];
//        [self.promptDetailBD setHidden:YES];
        
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
    }else if (button.tag==401){
        // 赎回
        self.ContinueCast.selected=NO;
        self.redemption.selected=YES;
    }
}

- (IBAction)depositClick:(id)sender {
    
    SYMSupportBankViewController *supportBank=[[SYMSupportBankViewController alloc]initWithNibName:@"SYMSupportBankViewController" bundle:nil];
    [self.navigationController pushViewController:supportBank animated:YES];
}

- (void)clickSlider:(id)sender {
    UISlider *paramSender=(UISlider *)sender;
    if ([paramSender isEqual:_mySlider]) {
        if (paramSender.value==0) {
            tipBD.transform=CGAffineTransformMakeTranslation((_mySlider.frame.size.width/100)*paramSender.value,0);
            _depositMoney.transform=CGAffineTransformMakeTranslation((_mySlider.frame.size.width/100)*paramSender.value,0);
        }else{
            tipBD.transform=CGAffineTransformMakeTranslation((_mySlider.frame.size.width/100)*paramSender.value-25,0);
            _depositMoney.transform=CGAffineTransformMakeTranslation((_mySlider.frame.size.width/100)*paramSender.value-25,0);
        }
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

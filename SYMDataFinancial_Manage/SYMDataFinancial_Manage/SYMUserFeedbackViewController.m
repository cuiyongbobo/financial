//
//  SYMUserFeedbackViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMUserFeedbackViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "MyTipsWindow.h"

@interface SYMUserFeedbackViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation SYMUserFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    //[self registerForKeyboardNotifications];
    [self customtoolBar];
//    UITapGestureRecognizer *_myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
//    [self.view addGestureRecognizer:_myTap];
}

-(void)tapBack:(UITapGestureRecognizer *) tap{
    [UIView animateWithDuration:0.3f animations:^{
        [self.TextViewInput resignFirstResponder];
        [self.TextFieldInput resignFirstResponder];
        self.BDView.transform = CGAffineTransformMakeTranslation(0,0);
        //self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
    }];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"意见反馈";
    
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
    if (self.BDView.frame.size.height-(self.Submit.frame.origin.y+self.Submit.frame.size.height)<height) {
        CGFloat Lowhight=height-(self.BDView.frame.size.height-(self.Submit.frame.origin.y+self.Submit.frame.size.height));
        [UIView animateWithDuration:0.3f animations:^{
            self.BDView.transform = CGAffineTransformMakeTranslation(0,-Lowhight);
        }];
    }
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}


#pragma mark-实现UITextView的代理

-(void)textViewDidChange:(UITextView *)textView
{
   // self.TextViewInput.text=  textView.text;
    if (textView.text.length == 0) {
        self.placeholder.text = @"你有什么话想对我说";
    }else{
        self.placeholder.text = @"";
    }
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
    [self.TextFieldInput  setInputAccessoryView:topView];
    [self.TextViewInput  setInputAccessoryView:topView];
}

-(void)dismissKeyBoard:(UIButton *)button{
    
    NSLog(@"点击完成按钮");
    [UIView  animateWithDuration:0.3f animations:^{
//        self.navigationController.view.transform=CGAffineTransformMakeTranslation(0,0);
        [self.TextFieldInput resignFirstResponder];
        [self.TextViewInput resignFirstResponder];
        self.BDView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (IBAction)ClickSubmit:(id)sender {
    [self.TextFieldInput resignFirstResponder];
    [self.TextViewInput resignFirstResponder];
    self.BDView.transform = CGAffineTransformMakeTranslation(0,0);
    if ([self judgeEmailString:self.TextFieldInput.text]) {
        // 提交反馈接口
        [self requestFeedback];
    }else{
        
        NSLog(@"邮箱不合法");
        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"邮箱不合法" backgroundcolor:white];
    }
}

#pragma mark- 请求反馈接口
-(void)requestFeedback
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    // UserfeedbackPublicDictnary
    paramDict=[[SYMPublicDictionary shareDictionary]UserfeedbackPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] content:self.TextViewInput.text email:self.TextFieldInput.text];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMFeedback_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"FeedbackresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            //NSDictionary *dict=responsedict[@"data"];
            
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 判断邮箱的合法性
-(BOOL)judgeEmailString:(NSString *)email//判断邮箱地址的合法性
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


@end

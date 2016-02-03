//
//  SYMResultsDetailsViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMResultsDetailsViewController.h"
#import "SYMConstantCenter.h"

@interface SYMResultsDetailsViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation SYMResultsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"交易结果详情";
    
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

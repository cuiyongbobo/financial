//
//  SYMPersonalMoreViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/10.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMPersonalMoreViewController.h"
#import "SYMPersonalMoreCell.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"
#import "SYMUserhelpcenterViewController.h"
#import "SYMAboutUsViewController.h"
#import "SYMofficialWeChatViewController.h"
#import "SYMUserFeedbackViewController.h"

@interface SYMPersonalMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *leftinformationDataArraySection;
    NSMutableArray *leftinformationDataArraySectiones;
}
@end

@implementation SYMPersonalMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self initData];
    //self.PersonalMoreTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"更多";
    
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

-(void)initData
{
    leftinformationDataArraySection=[[NSMutableArray alloc]init];
    leftinformationDataArraySectiones=[[NSMutableArray alloc]init];
    [leftinformationDataArraySection addObject:@"帮助中心"];
    [leftinformationDataArraySection addObject:@"用户反馈"];
    [leftinformationDataArraySectiones addObject:@"关于我们"];
    [leftinformationDataArraySectiones addObject:@"微信公众号"];
    [leftinformationDataArraySectiones addObject:@"客户服务热线"];
    self.PersonalMoreTable.tableFooterView=[[UIView alloc]init];
}

#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return leftinformationDataArraySection.count;
        }
            break;
        case 1:
        {
            return leftinformationDataArraySectiones.count;
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
    
    static NSString *Identity=@"cell";
    SYMPersonalMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
    
    if (cell==nil) {
        
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMPersonalMoreCell" owner:self options:nil] lastObject];
    }
    switch (indexPat.section) {
        case 0:
        {
            [cell.ArrowImageView setHidden:NO];
            [cell.PhoneNumber setHidden:YES];
            cell.InformationLabel.text=leftinformationDataArraySection[indexPat.row];
        }
            break;
        case 1:
        {
            [cell.PhoneNumber setHidden:YES];
            cell.InformationLabel.text=leftinformationDataArraySectiones[indexPat.row];
            if (indexPat.row==2) {
                [cell.PhoneNumber setHidden:NO];
                [cell.ArrowImageView setHidden:YES];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                SYMUserhelpcenterViewController *userHelp=[[SYMUserhelpcenterViewController alloc]initWithNibName:@"SYMUserhelpcenterViewController" bundle:nil];
                NSString *urlhtml=@"http://123.57.248.253/webapp/more?resource=help&terminal=2";
                userHelp.weburl=urlhtml;
                [self.navigationController pushViewController:userHelp animated:YES];
                
            }else if (indexPath.row==1)
            {
                SYMUserFeedbackViewController *feedback=[[SYMUserFeedbackViewController alloc]initWithNibName:@"SYMUserFeedbackViewController" bundle:nil];
                [self.navigationController pushViewController:feedback animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row==0) {
                SYMAboutUsViewController *userHelp=[[SYMAboutUsViewController alloc]initWithNibName:@"SYMAboutUsViewController" bundle:nil];
                NSString *urlhtml=@"http://123.57.248.253/webapp/more?resource=about_us&terminal=2";
                userHelp.weburl=urlhtml;
                [self.navigationController pushViewController:userHelp animated:YES];
                
            }else if (indexPath.row==1)
            {
                SYMofficialWeChatViewController *weChat=[[SYMofficialWeChatViewController alloc]initWithNibName:@"SYMofficialWeChatViewController" bundle:nil];
                [self.navigationController pushViewController:weChat animated:YES];
                
            }else if (indexPath.row==2)
            {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4001511511"];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48*SYMHEIGHTRATESCALE;
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UIView *headerView = [[UIView alloc] init];
    if (section==1) {
        headerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 10);//创建一个视图
        headerView.userInteractionEnabled=YES;
        headerView.backgroundColor=SYMBDClolor;
    }
    return headerView;
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

- (IBAction)ClickLogout:(id)sender {
    if ([[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:ISLogIN];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:IPhonenumber];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:SETPasswordStatus];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
@end

//
//  SYMPersonalCenterViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/4.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "SYMPersonalCenterViewController.h"
#import "SYMConstantCenter.h"
#import "PasswordManageViewController.h"
#import "PersonalCell.h"
#import "SYMPersonalMoreViewController.h"
#import "PersonalInformationViewController.h"
#import "LoginViewController.h"
#import "SYMPublicDictionary.h"
#import "ZplayNoject.h"

@interface SYMPersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel     *companyAccount;
    NSMutableArray *iconDataArray;
    NSMutableArray *leftinformationDataArray;
}
@end

@implementation SYMPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self.SendButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [self initData];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    // 定义Navigation的titleView
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"个人信息";
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:SYMFontColor];
    [_TitleImage addSubview:companyAccount];
}

-(void)initData
{
    iconDataArray=[[NSMutableArray alloc]init];
    leftinformationDataArray=[[NSMutableArray alloc]init];
    [iconDataArray addObject:@"icon_lock"];
    [iconDataArray addObject:@"icon_yaoqinghaoyou"];
    [iconDataArray addObject:@"icon_more"];
    [leftinformationDataArray addObject:@"密码管理"];
    [leftinformationDataArray addObject:@"好友邀请"];
    [leftinformationDataArray addObject:@"更多"];
    self.PersonTable.tableFooterView=[[UIView alloc]init];
}

- (IBAction)btnClick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if (button.tag==103) {
        NSLog(@"执行跳转操作");
        PersonalInformationViewController *information=[[PersonalInformationViewController alloc]initWithNibName:@"PersonalInformationViewController" bundle:nil];
        [self.navigationController pushViewController:information animated:YES];
    }
}

#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    static NSString *Identity=@"cell";
    PersonalCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
    
    if (cell==nil) {
        
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PersonalCell" owner:self options:nil] lastObject];
    }
    [cell.InformationRight setHidden:YES];
    switch (indexPat.section) {
        case 0:
        {
            cell.IconLeftImageView.image=[UIImage imageNamed:iconDataArray[indexPat.section]];
            cell.InformationLeft.text=leftinformationDataArray[indexPat.section];
            
        }
            break;
        case 1:
        {
            cell.IconLeftImageView.image=[UIImage imageNamed:iconDataArray[indexPat.section]];
            cell.InformationLeft.text=leftinformationDataArray[indexPat.section];
        }
            break;
        case 2:
        {
            cell.IconLeftImageView.image=[UIImage imageNamed:iconDataArray[indexPat.section]];
            cell.InformationLeft.text=leftinformationDataArray[indexPat.section];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击tableview某行的时候，cell的背景会变，设置为YES，鼠标（手指抬起的时候）背景会慢慢恢复（渐变的）。设置为NO，就是直接恢复了
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            PasswordManageViewController *passwordmanager=[[PasswordManageViewController alloc]initWithNibName:@"PasswordManageViewController" bundle:nil];
            [self.navigationController pushViewController:passwordmanager animated:YES];
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            SYMPersonalMoreViewController *personalMore=[[SYMPersonalMoreViewController alloc]initWithNibName:@"SYMPersonalMoreViewController" bundle:nil];
            [self.navigationController pushViewController:personalMore animated:YES];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];//创建一个视图
    
    headerView.userInteractionEnabled=YES;
    
    headerView.backgroundColor=SYMBDClolor;
    
    return headerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self determineUserIslogin];
    self.ShowInformation.text=[[NSUserDefaults standardUserDefaults]objectForKey:IPhonenumber];
}

#pragma mark- 判断用户是否登录
-(void)determineUserIslogin
{
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
    BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:userId];
    if (!b) { // 正常应该是!b
        // 登录成功
    }else{
        // 去登陆
        dispatch_async(dispatch_get_main_queue(), ^{
            // 测试登录
            LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:login animated:YES];
            login.backLogin=^{
                // 登录成功
            };
        });
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

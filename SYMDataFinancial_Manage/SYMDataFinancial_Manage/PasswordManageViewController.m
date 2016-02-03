//
//  PasswordManageViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/9.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "PasswordManageViewController.h"
#import "SYMConstantCenter.h"
#import "PersonalCell.h"
#import "SYMSetPaypasswordViewController.h"
#import "SYMSetpasswordViewController.h"
#import "GestureViewController.h"
#import "BtmSharePinPassWordViewController.h"
#import "SYMTabController.h"
#import "SYMPublicDictionary.h"
#import "SYMModifyPaypasswordViewController.h"
#import "SYMModifyloginpasswordViewController.h"
#import "SYMNavViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "SYMDataBaseCenter.h"
#import "SYMDataBaseModel.h"

@interface PasswordManageViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    UIButton *rightButton;
    NSMutableArray *iconDataArray;
    NSMutableArray *leftinformationDataArray;
    NSMutableArray *rightinformationDataArray;
}
@end

@implementation PasswordManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self initData];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"密码管理";
    
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
    iconDataArray=[[NSMutableArray alloc]init];
    leftinformationDataArray=[[NSMutableArray alloc]init];
    rightinformationDataArray=[[NSMutableArray alloc]init];
    [iconDataArray addObject:@"icon_lock"];
    [iconDataArray addObject:@"icon_yaoqinghaoyou"];
    [iconDataArray addObject:@"icon_shoushimima"];
    [leftinformationDataArray addObject:@"支付密码"];
    [leftinformationDataArray addObject:@"登录密码"];
    [leftinformationDataArray addObject:@"手势密码"];
    [rightinformationDataArray addObject:@"设置"];
    [rightinformationDataArray addObject:@"修改"];
    [rightinformationDataArray addObject:@"设置"];
    self.PasswordTable.tableFooterView=[[UIView alloc]init];
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
    [cell.InformationRight setHidden:NO];
    switch (indexPat.section) {
        case 0:
        {
            cell.IconLeftImageView.image=[UIImage imageNamed:iconDataArray[indexPat.section]];
            cell.InformationLeft.text=leftinformationDataArray[indexPat.section];
            //cell.InformationRight.text=rightinformationDataArray[indexPat.section];
            if (![[SYMPublicDictionary shareDictionary]judgeString:[[NSUserDefaults standardUserDefaults] objectForKey:SETPasswordStatus]]) {
                cell.InformationRight.text=@"修改";
            }else{
                cell.InformationRight.text=@"设置";
            }
        }
            break;
        case 1:
        {
            cell.IconLeftImageView.image=[UIImage imageNamed:iconDataArray[indexPat.section]];
            cell.InformationLeft.text=leftinformationDataArray[indexPat.section];
            cell.InformationRight.text=rightinformationDataArray[indexPat.section];
        }
            break;
        case 2:
        {
            cell.IconLeftImageView.image=[UIImage imageNamed:iconDataArray[indexPat.section]];
            cell.InformationLeft.text=leftinformationDataArray[indexPat.section];
            
            // 从数据库里面读取userid（判断这个 userid 下是否设置过手势密码）
            
            NSArray *array=[[SYMDataBaseCenter defaultDatabase]getAllinformationByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
            if (array.count!=0) {
                cell.InformationRight.text=@"重置";
            }else{
                cell.InformationRight.text=@"设置";
            }
            
            
//            if (![[SYMPublicDictionary shareDictionary]judgeString:[[NSUserDefaults standardUserDefaults]objectForKey:gestureFinalSaveKey]]) {
//                cell.InformationRight.text=@"重置";
//            }else{
//                cell.InformationRight.text=@"设置";
//            }
            
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
            if (![[SYMPublicDictionary shareDictionary]judgeString:SETPasswordStatus]) {
                SYMModifyPaypasswordViewController *passwordmanager=[[SYMModifyPaypasswordViewController alloc]initWithNibName:@"SYMModifyPaypasswordViewController" bundle:nil];
                [self.navigationController pushViewController:passwordmanager animated:YES];
            }else{
                SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                [tabcontrol hidenTabBar:YES];
                // 未帮卡
                BtmSharePinPassWordViewController *btmSPVc = [[BtmSharePinPassWordViewController alloc] init];
                btmSPVc.isinput=isHelpCard;
                [btmSPVc defaultStandPinPassword:self];
                btmSPVc.backPassword=^(NSString *password){
                    NSLog(@"1111");
                    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                    [tabcontrol hidenTabBar:NO];
                    // 跳转到理财超市页面
                    SYMTabController *myTab = (SYMTabController *)self.tabBarController;
                    [myTab setCurrentSelectIndex:1];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                };
                btmSPVc.close=^{
                    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                    [tabcontrol hidenTabBar:NO];
                };
                [self presentViewController:btmSPVc animated:NO completion:nil];
            }
        }
            break;
        case 1:
        {
            
            SYMModifyloginpasswordViewController *Modifylogin=[[SYMModifyloginpasswordViewController alloc]initWithNibName:@"SYMModifyloginpasswordViewController" bundle:nil];
            [self.navigationController pushViewController:Modifylogin animated:YES];
        }
            break;
        case 2:
        {
            // 设置手势密码
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            [self.navigationController pushViewController:gestureVc animated:YES];
//                if (![[SYMPublicDictionary shareDictionary]judgeString:[[NSUserDefaults standardUserDefaults]objectForKey:gestureFinalSaveKey]]) {
//                    // 重置手势密码
//                    
//                }else{
//                    // 设置手势密码
//                    GestureViewController *gestureVc = [[GestureViewController alloc] init];
//                    gestureVc.type = GestureViewControllerTypeSetting;
//                    [self.navigationController pushViewController:gestureVc animated:YES];
//                }
                
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
    [self.PasswordTable reloadData];
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

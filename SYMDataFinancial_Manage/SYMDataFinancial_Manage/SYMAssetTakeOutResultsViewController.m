//
//  SYMAssetTakeOutResultsViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMAssetTakeOutResultsViewController.h"
#import "SYMConstantCenter.h"
#import "SYMMyAssetTakeOutResultsTableViewCell.h"
#import "SYMMyAssetTakeOutResultsMoreTableViewCell.h"
#import "SYMTabController.h"
#import "SYMDataBaseModel.h"

@interface SYMAssetTakeOutResultsViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation SYMAssetTakeOutResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self  initNavigationView];
    self.BDAssetTableView.tableFooterView=[[UIView alloc]init];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"交易结果";
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
            return _drawalresultArray.count;
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
            SYMMyAssetTakeOutResultsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
            if (cell==nil) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMMyAssetTakeOutResultsTableViewCell" owner:self options:nil] lastObject];
            }
            return cell;
        }
            break;
            
        case 1:
        {
            static NSString *formalIdentity=@"cell";
            SYMMyAssetTakeOutResultsMoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:formalIdentity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMMyAssetTakeOutResultsMoreTableViewCell" owner:self options:nil]lastObject];
            }
            WithdrawalResults *model=_drawalresultArray[indexPat.row];
            cell.walletName.text=[NSString stringWithFormat:@"%@",model.companyName];
            cell.cashMoneyLabel.text=[NSString stringWithFormat:@"%@",model.cashMoney];
            cell.toDateLabel.text=[NSString stringWithFormat:@"%@",model.toDate];
            cell.bankNameLabel.text=[NSString stringWithFormat:@"%@",model.bankName];
            cell.bankNo.text=[NSString stringWithFormat:@"%@",model.cardNo];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
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
            
        }
            break;
        default:
            break;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 134*SYMHEIGHTRATESCALE;
    }else{
        return 90*SYMHEIGHTRATESCALE;
    }
}

// tableview 的section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 30;
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

-(IBAction)btnclick:(id)sender
{
    UIButton *button=(UIButton *)sender;
    
    if (button.tag==400) {
        SYMTabController *myTab = (SYMTabController *)self.tabBarController;
        [myTab setCurrentSelectIndex:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SYMTabController *tabcontro=(SYMTabController *)self.tabBarController;
    [tabcontro hidenTabBar:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SYMTabController *tabcontro=(SYMTabController *)self.tabBarController;
    [tabcontro hidenTabBar:NO];
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

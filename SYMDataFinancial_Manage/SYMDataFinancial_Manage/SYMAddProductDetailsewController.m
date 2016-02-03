//
//  SYMAddProductDetailsewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/26.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMAddProductDetailsewController.h"
#import "SYMConstantCenter.h"
#import "SymAddProductDetailMoreTableViewCell.h"
#import "SymAddProductDetailMoreTableViewCell.h"
#import "SYMPersonalMoreCell.h"
#import "SymAddProductDetailTableViewCell.h"
#import "SYMTabController.h"
#import "SYMSupportBankViewController.h"

@interface SYMAddProductDetailsewController ()<UIWebViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    double cellHeight;
    int cellRefreshCount;
}
@end

@implementation SYMAddProductDetailsewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    self.BDTableView.tableFooterView=[[UIView alloc]init];
    cellRefreshCount=0;
    // self.BDTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    switch (indexPat.section) {
        case 0:
        {
            static NSString *Identity=@"cell";
            SymAddProductDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SymAddProductDetailTableViewCell" owner:self options:nil] lastObject];
            }
            cell.MoneyLabel.text=[NSString stringWithFormat:@"%@",self.model.minInvest];
            cell.MultipleLabel.text=[NSString stringWithFormat:@"%@的倍数递增",self.model.raiseInvest];
            cell.MonthLabel.text=[NSString stringWithFormat:@"%@",self.model.period];
            cell.UnitLabel.text=[self matchLimtTime:[NSString stringWithFormat:@"%@",self.model.unit]];
            cell.DealWithLabel.text=[self stringorder:[NSString stringWithFormat:@"%@",self.model.defaultExpireProcessMode]];
            cell.PoundageLabel.text=[NSString stringWithFormat:@"%@%@手续费",self.model.rate,@"%"];
            cell.StartTimeLabel.text=[NSString stringWithFormat:@"%@",self.startTimer];
            cell.EndTimeLabel.text=[NSString stringWithFormat:@"%@",self.endTiner];
            cell.RiskLevel.text=[NSString stringWithFormat:@"%@",self.model.riskLevel];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *Identityre=@"cell";
            SYMPersonalMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:Identityre];
            
            if (cell==nil) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMPersonalMoreCell" owner:self options:nil] lastObject];
            }
            cell.InformationLabel.text=@"银行支持及限额";
            cell.InformationLabel.textColor=SYMLightGreyColor;
            cell.InformationLabel.font=[UIFont systemFontOfSize:14.0f];
            [cell.PhoneNumber setHidden:YES];
            return cell;
        }
            break;
        case 2:
        {
            static NSString *Identityres=@"cell";
            SymAddProductDetailMoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identityres];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SymAddProductDetailMoreTableViewCell" owner:self options:nil] lastObject];
            }
            
            NSString *url=@"http://123.57.248.253/uap_server/findProductDesc?channelCode=HLC&productCode=jinzhu30Dd&productCatCode=4&terminalType=2&requestVersion=android1.0";
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [cell.DescribeWebView loadRequest:request];
            cell.DescribeWebView.delegate=self;
            if (!cellRefreshCount==1) {
                cellHeight=cell.DescribeWebView.frame.size.height;
            }
            //dispatch_async(dispatch_get_main_queue(), ^{
            self.BDTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            //});
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
            SYMSupportBankViewController *support=[[SYMSupportBankViewController alloc]initWithNibName:@"SYMSupportBankViewController" bundle:nil];
            support.distributorCode=self.model.distributorCode;
            [self.navigationController pushViewController:support animated:YES];
            
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 10*SYMHEIGHTRATESCALE;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 248*SYMHEIGHTRATESCALE;
    }else if (indexPath.section==2)
    {
        return (cellHeight+35)*SYMHEIGHTRATESCALE;
    }
    return 45*SYMHEIGHTRATESCALE;
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame=CGRectMake(0, 0, tableView.bounds.size.width, 10);//创建一个视图
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=SYMBDClolor;
    return headerView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}


#pragma mark- 匹配续投
-(NSString *)stringorder:(NSString *)dealWith{
    NSString *delawithresult;
    if ([dealWith isEqualToString:@"0"]) {
        delawithresult=@"不支持续投";
    }else if ([dealWith isEqualToString:@"1"]){
        delawithresult=@"本金续投";
    }else if ([delawithresult isEqualToString:@"2"]){
        delawithresult=@"本息续投";
    }else if ([delawithresult isEqualToString:@"3"]){
        delawithresult=@"到期兑付";
    }
    return delawithresult;
}


#pragma mark- 匹配日期
-(NSString *)matchLimtTime:(NSString *)unit{
    
    NSString *limitTim=@"无";
    if ([unit isEqualToString:@"Y"]) {
        limitTim=@"年";
    }else if ([unit isEqualToString:@"M"]){
        limitTim=@"个月";
    }else if ([unit isEqualToString:@"D"]){
        limitTim=@"日";
    }
    return limitTim;
}

#pragma mark- webViewDelegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    cellRefreshCount++;
    // 防止一直刷新
    if (cellRefreshCount==1) {
        cellHeight=webView.frame.size.height;
        //刷新第3个section，第1行
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
        NSArray *paths = [NSArray arrayWithObjects:path,nil];
        [self.BDTableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    }else
    {
        return;
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

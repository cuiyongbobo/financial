//
//  SYMMyAssetsViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "SYMMyAssetsViewController.h"
#import "SYMConstantCenter.h"
#import "MyAssetSectionOneTableViewCell.h"
#import "MyAssetSectionSecondTableViewCell.h"
#import "SYMAssetTakeOutResultsViewController.h"
#import "SYMAssetTransactionRecordViewController.h"
#import "SYMAssetRegularFinancialViewController.h"
#import "SYMAssetReflectViewController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"
#import "LoginViewController.h"
#import "MyTipsWindow.h"
#import "ZplayNoject.h"
#import "BtmMobile.h"

@interface SYMMyAssetsViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *IconArray;
    NSMutableArray *IconNameArray;
    MyAsset *_assetModel;
}
@end

@implementation SYMMyAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self initControls];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"我的资产";
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:SYMFontColor];
    [_TitleImage addSubview:companyAccount];
}

-(void)initControls
{
    self.BDTableView.tableFooterView=[[UIView alloc]init];
    IconArray=[[NSMutableArray alloc]init];
    IconNameArray=[[NSMutableArray alloc]init];
    [IconArray addObject:@"anytime"];
    [IconArray addObject:@"fixdate"];
    [IconNameArray addObject:@"活期理财"];
    [IconNameArray addObject:@"定期理财"];
}

#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
            return 1;
        }
            break;
        case 2:
        {
            return 1;
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
            MyAssetSectionOneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"MyAssetSectionOneTableViewCell" owner:self options:nil] lastObject];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.TotalAssets.text=[NSString stringWithFormat:@"%@",_assetModel.totalAssets];
            });
            cell.Yesterdayearn.text=[NSString stringWithFormat:@"%@",_assetModel.yesterdayIncome];
            cell.CumulativeEarn.text=[NSString stringWithFormat:@"%@",_assetModel.totalIncome];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *formalIdentity=@"cell";
            MyAssetSectionSecondTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:formalIdentity];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"MyAssetSectionSecondTableViewCell" owner:self options:nil]lastObject];
            }
            
            cell.AssetIcon.image=[UIImage imageNamed:IconArray[indexPat.row+1]];
            cell.AssetName.text=IconNameArray[indexPat.row+1];
            cell.RegularAmount.text=[NSString stringWithFormat:@"%@元",_assetModel.regularAmount];
#if 0
            if (indexPat.row==0) {
                //                cell.AssetIcon.image=[UIImage imageNamed:IconArray[indexPat.row]];
                //                cell.AssetName.text=IconNameArray[indexPat.row];
                //                [cell.RegularAmount setHidden:YES];
            }else{
                cell.AssetIcon.image=[UIImage imageNamed:IconArray[indexPat.row]];
                cell.AssetName.text=IconNameArray[indexPat.row];
                cell.RegularAmount.text=[NSString stringWithFormat:@"%@元",_assetModel.regularAmount];
            }
#endif
            return cell;
        }
            break;
        case 2:
        {
            static NSString *formalIdentitymore=@"cell";
            MyAssetSectionSecondTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:formalIdentitymore];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"MyAssetSectionSecondTableViewCell" owner:self options:nil]lastObject];
            }
            cell.AssetIcon.image=[UIImage imageNamed:@"list"];
            cell.AssetName.text=@"交易记录";
            [cell.RegularAmount setHidden:YES];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:
        {
            //            SYMAssetTakeOutResultsViewController *outresult=[[SYMAssetTakeOutResultsViewController alloc]initWithNibName:@"SYMAssetTakeOutResultsViewController" bundle:nil];
            //            [self.navigationController pushViewController:outresult animated:YES];
        }
            break;
        case 1:
        {
            SYMAssetRegularFinancialViewController *regularfinanci=[[SYMAssetRegularFinancialViewController alloc]initWithNibName:@"SYMAssetRegularFinancialViewController" bundle:nil];
            [self.navigationController pushViewController:regularfinanci animated:YES];
#if 0
            if (indexPath.row==0) {
                //                SYMAssetReflectViewController *reflect=[[SYMAssetReflectViewController alloc]initWithNibName:@"SYMAssetReflectViewController" bundle:nil];
                //                [self.navigationController pushViewController:reflect animated:YES];
            }else{
                SYMAssetRegularFinancialViewController *regularfinanci=[[SYMAssetRegularFinancialViewController alloc]initWithNibName:@"SYMAssetRegularFinancialViewController" bundle:nil];
                [self.navigationController pushViewController:regularfinanci animated:YES];
            }
#endif
            
        }
            break;
        case 2:
        {
            SYMAssetTransactionRecordViewController *record=[[SYMAssetTransactionRecordViewController alloc]initWithNibName:@"SYMAssetTransactionRecordViewController" bundle:nil];
            [self.navigationController pushViewController:record animated:YES];
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 74*SYMHEIGHTRATESCALE;
    }else{
        return 60*SYMHEIGHTRATESCALE;
    }
}

// tableview 的section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 10;
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

#pragma mark- 请求我的资产接口
-(void)requestMyAsset
{
    [[BtmMobile shareBtmMoile]startMove:self];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]MyAssetsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMMyAssets_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dict=responsedict[@"data"];
            _assetModel=[[MyAsset alloc]init];
            _assetModel.currentAmount=dict[@"currentAmount"];
            _assetModel.regularAmount=dict[@"regularAmount"];
            _assetModel.totalAssets=dict[@"totalAssets"];
            _assetModel.totalIncome=dict[@"totalIncome"];
            _assetModel.yesterdayIncome=dict[@"yesterdayIncome"];
            [self.BDTableView reloadData];
            [[BtmMobile shareBtmMoile]stopMove];
        }else{
            NSLog(@"message=%@",responsedict[@"message"]);
            [[BtmMobile shareBtmMoile]stopMove];
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:responsedict[@"message"] backgroundcolor:white];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        [[BtmMobile shareBtmMoile]stopMove];
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self determineUserIslogin];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark- 判断用户是否登录
-(void)determineUserIslogin
{
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
    BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:userId];
    if (!b) { // 正常应该是!b
        // 登录过
        if ([self isMainhaveNetwork]) {
            [self requestMyAsset];
        }
        
    }else{
        // 去登陆
        dispatch_async(dispatch_get_main_queue(), ^{
            // 测试登录
            LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:login animated:YES];
            login.backLogin=^{
                // 登录成功
                if ([self isMainhaveNetwork]) {
                    [self requestMyAsset];
                }
                
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

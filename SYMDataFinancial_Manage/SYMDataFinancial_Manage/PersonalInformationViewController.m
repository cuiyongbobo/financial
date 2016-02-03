//
//  PersonalInformationViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/25.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "SYMConstantCenter.h"
#import "PersonalInformationTableViewCell.h"
#import "SYMPersonalMoreCell.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"
#import "SYMTabController.h"
#import "BTMQRTool.h"
#import "SYMBindingBankcardViewController.h"

@interface PersonalInformationViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *_dataArray;
}
@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    self.BDTableView.tableFooterView=[[UIView alloc]init];
    self.BDTableView.separatorStyle = NO;
    _dataArray=[[NSMutableArray alloc]init];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"个人信息";
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    switch (indexPat.section) {
        case 0:
        {
            static NSString *Identity=@"cell";
            PersonalInformationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
            
            if (cell==nil) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"PersonalInformationTableViewCell" owner:self options:nil] lastObject];
            }
            if (_dataArray.count!=0) {
                PersonalInformation *model=_dataArray[0];
                cell.UserNameLabel.text=[NSString stringWithFormat:@"%@",model.realName];
                cell.IdCard.text=[NSString stringWithFormat:@"%@",model.idCardNo];
                cell.IphoneNo.text=[NSString stringWithFormat:@"%@",model.mobile];
                cell.selfCode.text=[NSString stringWithFormat:@"%@",model.inviteCode];
                cell.QrcodeImageView.image=[self createQRCode];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *Identity=@"cell";
            SYMPersonalMoreCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
            
            if (cell==nil) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMPersonalMoreCell" owner:self options:nil] lastObject];
            }
            cell.InformationLabel.textColor=SYMLightGreyColor;
            cell.InformationLabel.font=[UIFont systemFontOfSize:13.0f];
            cell.InformationLabel.text=@"银行卡";
            [cell.PhoneNumber setHidden:YES];
            return cell;
        }
            break;
        default:
            return nil;
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
            //  跳转到绑定银行卡
            SYMBindingBankcardViewController *bankcardContro=[[SYMBindingBankcardViewController alloc]initWithNibName:@"SYMBindingBankcardViewController" bundle:nil];
            [self.navigationController pushViewController:bankcardContro animated:YES];
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
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 317*SYMHEIGHTRATESCALE;
    }else if (indexPath.section==1)
    {
        return  45*SYMHEIGHTRATESCALE;
    }else{
        return 0;
    }
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
    [self requestPersonInformation];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

#pragma mark- 获取个人信息
-(void)requestPersonInformation
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]MyAssetsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMpersonalInformation_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dict=responsedict[@"data"];
            PersonalInformation *information=[[PersonalInformation alloc]init];
            information.idCardNo=dict[@"idCardNo"];
            information.inviteCode=dict[@"selfCode"];
            information.mobile=dict[@"mobile"];
            information.realName=dict[@"realName"];
            [_dataArray addObject:information];
            [self.BDTableView reloadData];
            // 存储个人信息
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",dict[@"userType"]] forKey:UserType];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:dict[@"isDistribute"] forKey:ISdistribution];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 生成收款二维码

-(UIImage *)createQRCode
{
    //生成二维码
    //需求:从当前账户中拿出收款地址
    NSString *receiveAddress=@"https://itunes.apple.com/cn/app/wang-yi-you-qian-zi-dong-ji/id992055304?mt=8";
    NSMutableString *qrCreateStr = [[NSMutableString alloc]init];
    [qrCreateStr appendString:receiveAddress];
    //生成二维码图片
    UIImage *myQrImage = [BTMQRTool createQRImageWithString:qrCreateStr imageSize:250 withPointType:QRPointRect withPositionType:QRPositionNormal withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];//注意此处的二维码颜色需要用grb模式,用系统的red,black会失效
    return myQrImage;
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

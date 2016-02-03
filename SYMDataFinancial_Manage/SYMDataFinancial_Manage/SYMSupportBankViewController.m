//
//  SYMSupportBankViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/18.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMSupportBankViewController.h"
#import "SYMConstantCenter.h"
#import "SYMSupportBankTableViewCell.h"
#import "SYMAFNHttp.h"
#import "SYMPublicDictionary.h"
#import "SYMDataBaseModel.h"

@interface SYMSupportBankViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSArray *bankiconArray;
    NSMutableArray *bankNameArray;
    NSMutableArray *bankInformationArray;
}
@end

@implementation SYMSupportBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    self.BDInformationTable.tableFooterView=[[UIView alloc]init];
    [self SetTableViewHeaderViewS];
    bankInformationArray=[[NSMutableArray alloc]init];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"支持银行";
    
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

-(void)initData{
    //bankiconArray=[[NSMutableArray alloc]init];
    bankNameArray=[[NSMutableArray alloc]init];
    bankInformationArray=[[NSMutableArray alloc]init];
    //    //读取plist
    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"IconPlist" ofType:@"plist"];
    //    bankiconArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSArray *namearray=@[@"交通银行",@"农业银行",@"工商银行",@"建设银行"];
    bankNameArray=[namearray mutableCopy];
    // [bankInformationArray addObject:@"单笔限额"];
    [bankInformationArray addObject:@"万元，日累计20万，单月20万"];
}

#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bankInformationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    static NSString *Identity=@"cell";
    SYMSupportBankTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMSupportBankTableViewCell" owner:self options:nil]lastObject];
    }
    if (bankInformationArray.count!=0) {
        BankChoose *model=bankInformationArray[indexPat.row];
        cell.bankIcon.image=[UIImage imageNamed:model.bankCode];
        cell.bankName.text=model.bankName;
        cell.information.text=model.memo;
        [cell.informationMore setHidden:YES];
        [cell.informationMoney setHidden:YES];
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击tableview某行的时候，cell的背景会变，设置为YES，鼠标（手指抬起的时候）背景会慢慢恢复（渐变的）。设置为NO，就是直接恢复了
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    SYMSupportBankTableViewCell *cell=(SYMSupportBankTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    BankChoose *model=bankInformationArray[indexPath.row];
    NSLog(@"model.bankCode=%@",model.bankCode);
    [[NSNotificationCenter defaultCenter]postNotificationName:ReturnData object:self userInfo:@{@"key":[NSString stringWithFormat:@"%@",cell.bankName.text],@"bankCode":[NSString stringWithFormat:@"%@",model.bankCode]}];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*SYMHEIGHTRATESCALE;
}

// 设置tableview Header
-(void)SetTableViewHeaderViewS{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.BDInformationTable.frame.size.width, 45*SYMWIDthRATESCALE)];
    [headerView setBackgroundColor:SYMBDClolor];
    UILabel *Title=[[UILabel alloc]init];
    Title.text=@"交易限额由各银行定制，若有不同请以银行为准";
    Title.textColor=SYMLightGreyColor;
    Title.font=[UIFont systemFontOfSize:12];
    [headerView addSubview:Title];
    self.BDInformationTable.tableHeaderView=headerView;
    Title.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:Title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:Title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBankChoose:@"" distributorCode:self.distributorCode];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark- 选择银行卡
-(void)requestBankChoose:(NSString *)userId distributorCode:(NSString *) distributorCode{
    // BankChoosePublicDictnary
    NSMutableDictionary *paramDict=[[SYMPublicDictionary shareDictionary]BankChoosePublicDictnary:userId distributorCode:distributorCode];
    [SYMAFNHttp post:SYMBankChosse_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObjBankChoose-->%@",responsedict);
        BOOL b=[[SYMPublicDictionary shareDictionary]judgeArray:responsedict[@"data"]];
        if (!b) {
            NSMutableArray *dataArray=responsedict[@"data"];
            for (NSDictionary *dict in dataArray) {
                BankChoose *model=[[BankChoose alloc]init];
                model.bankCode=dict[@"bankCode"];
                model.bankName=dict[@"bankName"];
                model.distributorCode=dict[@"distributorCode"];
                model.isNote=dict[@"isNote"];
                model.memo=dict[@"memo"];
                model.payBankCode=dict[@"payBankCode"];
                model.payMode=dict[@"payMode"];
                model.url=dict[@"url"];
                [bankInformationArray addObject:model];
                [self.BDInformationTable reloadData];
            }
        }else{
            return;
        }
        
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
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

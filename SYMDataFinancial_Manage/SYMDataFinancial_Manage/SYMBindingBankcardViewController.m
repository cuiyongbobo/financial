//
//  SYMBindingBankcardViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/26.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMBindingBankcardViewController.h"
#import "MyAssetSectionSecondTableViewCell.h"
#import "SYMConstantCenter.h"
#import "SYMBindCardTableViewCell.h"
#import "SYMTabController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"

@interface SYMBindingBankcardViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *_bankArray;
}
@end

@implementation SYMBindingBankcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.BDtableView.tableFooterView=[[UIView alloc]init];
    //self.BDtableView.separatorStyle = NO;
    _bankArray=[[NSMutableArray alloc]init];
    [self initNavigationView];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"绑定银行卡";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    static NSString *Identity=@"cell";
    SYMBindCardTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
    if (cell==nil) {
        
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMBindCardTableViewCell" owner:self options:nil] lastObject];
    }
    if (_bankArray.count!=0) {
        SelfBankCard *model=_bankArray[indexPat.row];
        // 截取字符串
        NSString *cardNo=[model.cardNo substringFromIndex:model.cardNo.length-4];
        cell.BankIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.bankCode]];
        cell.BankName.text=[NSString stringWithFormat:@"%@",model.bankName];
        cell.BankNo.text=[NSString stringWithFormat:@"%@",cardNo];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击tableview某行的时候，cell的背景会变，设置为YES，鼠标（手指抬起的时候）背景会慢慢恢复（渐变的）。设置为NO，就是直接恢复了
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
    return 54*SYMHEIGHTRATESCALE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    [self requestbindCard];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

#pragma mark- 请求帮卡接口
-(void)requestbindCard
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]MyAssetsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMBingBankCard_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *array=responsedict[@"data"];
            for (NSDictionary *dict in array) {
                SelfBankCard *bankcard=[[SelfBankCard alloc]init];
                bankcard.bankCode=dict[@"bankCode"];
                bankcard.bankName=dict[@"bankName"];
                bankcard.cardNo=dict[@"cardNo"];
                [_bankArray addObject:bankcard];
            }
            [self.BDtableView reloadData];
            self.tableHeight.constant=54*_bankArray.count;
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

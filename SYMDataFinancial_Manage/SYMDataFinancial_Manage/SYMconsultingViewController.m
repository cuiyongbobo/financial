//
//  SYMconsultingViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMconsultingViewController.h"
#import "SYMConstantCenter.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"
#import "SYMTabController.h"
#import "SYMconsultingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SYMexchangeRateViewController.h"

@interface SYMconsultingViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *_bannerArray;
}
@end

@implementation SYMconsultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationView];
    _bannerArray=[[NSMutableArray alloc]init];
    self.BDtableview.tableFooterView=[[UIView alloc]init];
    self.BDtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"资讯";
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    if (_bannerArray.count!=0) {
        [_bannerArray removeAllObjects];
    }
    [self requestPersonalactivities];
}

-(void)viewWillDisappear:(BOOL)animated
{
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

#pragma mark -个人活动请求-获取banner
-(void)requestPersonalactivities{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]personalActivitiesPublicDictnary:@"47094c90c8229532"];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMPersonalActivities_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObj-->%@",responsedict);
        NSDictionary *Maindict=responsedict;
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dataDict=Maindict[@"data"];
            NSMutableArray *contentsArray=dataDict[@"contents"];
            for (NSDictionary *dict in contentsArray) {
                FinancialSupermarket *model=[[FinancialSupermarket alloc]init];
                model.content=dict[@"content"];
                model.contentId=dict[@"contentId"];
                model.contentType=dict[@"contentType"];
                model.createTime=dict[@"createTime"];
                model.imgUrl=dict[@"imgUrl"];
                model.linkUrl=dict[@"linkUrl"];
                model.orders=dict[@"orders"];
                model.remark=dict[@"remark"];
                model.showType=dict[@"showType"];
                model.title=dict[@"title"];
                [_bannerArray addObject:model];
            }
            [self.BDtableview reloadData];
        }else{
            return;
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bannerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    static NSString *Identity=@"cell";
    SYMconsultingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMconsultingTableViewCell" owner:self options:nil] lastObject];
    }
    if (_bannerArray.count!=0) {
        FinancialSupermarket *model=_bannerArray[indexPat.row];
        NSString *subIndexstr=[model.createTime substringToIndex:10];
        cell.showDateLabel.text=[NSString stringWithFormat:@"%@",subIndexstr];
        NSString *picture=[NSString stringWithFormat:@"%@%@",SYMBannerAPI,model.imgUrl];
        NSLog(@"picture==%@",picture);
        [cell.contentPicter sd_setImageWithURL:[NSURL URLWithString:picture]
                              placeholderImage:[UIImage imageNamed:@""]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_bannerArray.count!=0) {
        FinancialSupermarket *model=_bannerArray[indexPath.row];
        SYMexchangeRateViewController *rate=[[SYMexchangeRateViewController alloc]initWithNibName:@"SYMexchangeRateViewController" bundle:nil];
        rate.weburl=[NSString stringWithFormat:@"%@",model.linkUrl];
        [self.navigationController pushViewController:rate animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 184*SYMHEIGHTRATESCALE;
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

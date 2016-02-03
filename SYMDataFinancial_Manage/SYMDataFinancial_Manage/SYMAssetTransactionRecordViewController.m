//
//  SYMAssetTransactionRecordViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/20.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMAssetTransactionRecordViewController.h"
#import "SYMConstantCenter.h"
#import "SYMAssetRecordsTableViewCell.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"
#import "MJRefresh.h"
#import "BtmSharePinPassWordViewController.h"
#import "SYMTabController.h"
#import "BtmMobile.h"


@interface SYMAssetTransactionRecordViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    UITableView *_fineSelectTableView;
    UITableView *_regularTableView;
    NSMutableArray *_groupArray;
    NSMutableArray *_groupArraymore;
    NSMutableArray *_groupArrayregular;
    NSMutableArray *_groupArraymoreregular;
    int _finecurrentPage;
    int _regularcurrentPage;
    bool istrueTimes;
}
@end

@implementation SYMAssetTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self initViews];
    [self initControls];
    _fineSelectTableView.header.updatedTimeHidden=YES;
    _regularTableView.header.updatedTimeHidden=YES;
    
    // self.automaticallyAdjustsScrollViewInsets = NO;  // 去除底部空白
    //[_fineSelectTableView.header setImages:@"" forState:MJRefreshStateIdle];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"交易记录";
    
    // 定义Navigation 的左右按钮
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

-(void)initViews
{
    _groupArray =[[NSMutableArray alloc]init];
    _groupArraymore=[[NSMutableArray alloc]init];
    _groupArrayregular=[[NSMutableArray alloc]init];
    _groupArraymoreregular=[[NSMutableArray alloc]init];
    _finecurrentPage=1;
    _regularcurrentPage=1;
    CGFloat width = BTMWidth;
    CGFloat height =BTMHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    _fineSelectTableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height-165*SYMHEIGHTRATESCALE) style:UITableViewStylePlain];
    _fineSelectTableView.delegate = self;
    _fineSelectTableView.dataSource = self;
    [self.BDScrollerView addSubview:_fineSelectTableView];
    
    x = width;
    height =_fineSelectTableView.frame.size.height;
    _regularTableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
    _regularTableView.delegate = self;
    _regularTableView.dataSource = self;
    [self.BDScrollerView addSubview:_regularTableView];
    
    self.BDScrollerView.contentSize = CGSizeMake(width*2, self.BDScrollerView.contentSize.height);
    self.BDScrollerView.pagingEnabled = YES;
    self.BDScrollerView.bounces = NO;
    self.BDScrollerView.showsHorizontalScrollIndicator = NO;
    self.BDScrollerView.showsVerticalScrollIndicator = NO;
    self.BDScrollerView.delegate =self;
}

-(void)initControls
{
    _fineSelectTableView.tableFooterView=[[UIView alloc]init];
    _regularTableView.tableFooterView=[[UIView alloc]init];
    [_regularTableView setBackgroundColor:SYMBDClolor];
    [_fineSelectTableView setBackgroundColor:SYMBDClolor];
    self.HeaderHeightConstr.constant=45*SYMHEIGHTRATESCALE;
    self.AccordWidth.constant=BTMWidth/2;
    [self.BuyIn pointInside:CGPointMake(300, 300) withEvent:nil];
    [self.Withdrawal pointInside:CGPointMake(300, 300) withEvent:nil];
    [_fineSelectTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(dofineHeaderRefresh)];
    [_regularTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(doregularfineHeaderRefresh)];
    [_fineSelectTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(dofineFooterRefresh)];
    [_regularTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(doregularFooterRefresh)];
}

// 设置tableview Header
-(void)SetTableViewHeaderViewS{
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,_fineSelectTableView.frame.size.width, 45*SYMWIDthRATESCALE)];
    [headerView setBackgroundColor:SYMFontColor];
    
    UILabel *Title=[[UILabel alloc]init];
    Title.text=@"交易限额由各银行定制，若有不同请以银行为准";
    Title.textColor=SYMLightGreyColor;
    Title.font=[UIFont systemFontOfSize:12];
    [headerView addSubview:Title];
    _fineSelectTableView.tableHeaderView=headerView;
    
    Title.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:Title attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:Title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _fineSelectTableView) {
        return _groupArray.count;
    }else{
        return _groupArrayregular.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _fineSelectTableView) {
        return [_groupArray[section] count];
    }else{
        return [_groupArrayregular[section]count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_fineSelectTableView) {
        return 66*SYMHEIGHTRATESCALE;
    }else{
        return  66*SYMHEIGHTRATESCALE;
    }
}

// 设置组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _fineSelectTableView) {
        return 20*SYMHEIGHTRATESCALE;
    }else{
        return 20*SYMHEIGHTRATESCALE;
    }
}

//自定义section的头部
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];//创建一个视图
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=SYMBDClolor;
    UILabel *TitleLabel=[[UILabel alloc]init];
    [headerView addSubview:TitleLabel];
    TitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:TitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeading multiplier:1 constant:23]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:TitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    if (tableView==_fineSelectTableView) {
        if (_groupArray.count!=0) {
            TitleLabel.text=_groupArraymore[section];
        }else{
            TitleLabel.text=@"";
        }
    }else if (tableView==_regularTableView){
        if (_groupArrayregular.count!=0) {
            TitleLabel.text=_groupArraymoreregular[section];
        }else{
            TitleLabel.text=@"";
        }
    }
    TitleLabel.font=[UIFont systemFontOfSize:13.0];
    [TitleLabel setTextColor:SYMLightGreyColor];
    TitleLabel.textAlignment=NSTextAlignmentLeft;
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_regularTableView) {
        static NSString *identity=@"cell";
        SYMAssetRecordsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMAssetRecordsTableViewCell" owner:self options:nil]lastObject];
        }
        if (_groupArrayregular.count!=0) {
            TransactionRecords *model=_groupArrayregular[indexPath.section][indexPath.row];
            cell.ThemeLabel.text=[NSString stringWithFormat:@"%@",model.publishName];
            cell.ShowTimeLabel.text=[self getNowDate:model.spendTime];
            cell.TransactionAmountLabel.text=[NSString stringWithFormat:@"%@元",model.amount];
            cell.TransactionStatusLabel.text=[self filterTransactionstatus:model.status];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView==_fineSelectTableView){
        
        static NSString *identitySelect = @"cell";
        SYMAssetRecordsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identitySelect];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMAssetRecordsTableViewCell" owner:self options:nil]lastObject];
        }
        
        if (_groupArray.count!=0) {
            TransactionRecords *model=_groupArray[indexPath.section][indexPath.row];
            cell.ThemeLabel.text=[NSString stringWithFormat:@"%@",model.publishName];
            cell.ShowTimeLabel.text=[self getNowDate:model.spendTime];
            cell.TransactionAmountLabel.text=[NSString stringWithFormat:@"%@元",model.amount];
            cell.TransactionStatusLabel.text=[self filterTransactionstatus:model.status];
            if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"5"]) {
                [cell.TransactionStatusLabel setTextColor:[UIColor redColor]];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击tableview某行的时候，cell的背景会变，设置为YES，鼠标（手指抬起的时候）背景会慢慢恢复（渐变的）。设置为NO，就是直接恢复了
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(IBAction)slider:(id)sender
{
    UIButton *button=(UIButton *)sender;
    if (button.tag==200) {
        [UIView animateWithDuration:0.3f animations:^{
            self.SliderImageView.transform=CGAffineTransformMakeTranslation(0,0);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 精选
            _fineSelectTableView.frame = CGRectMake(_fineSelectTableView.frame.origin.x, _fineSelectTableView.frame.origin.y, _fineSelectTableView.frame.size.width,_fineSelectTableView.frame.size.height);
            [UIView animateWithDuration:1/60.0 animations:^{
                self.BDScrollerView.contentOffset = CGPointMake(0, 0);
            }];
        });
        
    }else if (button.tag==201){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.SliderImageView.transform=CGAffineTransformMakeTranslation(self.SliderImageView.frame.size.width,0);
        }];
        //sleep(5);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_groupArrayregular.count==0) { // _groupArrayregular
                if (istrueTimes) {
                    istrueTimes=NO;
                    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                    [tabcontrol hidenTabBar:YES];
                    // 邀请码
                    BtmSharePinPassWordViewController *btmSPVc = [[BtmSharePinPassWordViewController alloc] init];
                    btmSPVc.isinput=isTransactionrecords;
                    [btmSPVc defaultStandPinPassword:self];
                    btmSPVc.backPassword = ^(NSString *password)
                    {
                        
                    };
                    btmSPVc.close=^{
                        SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                        [tabcontrol hidenTabBar:NO];
                    };
                    [self presentViewController:btmSPVc animated:NO completion:nil];
                }
            }
            _regularTableView.frame = CGRectMake(_regularTableView.frame.origin.x, _regularTableView.frame.origin.y, _regularTableView.frame.size.width,_regularTableView.frame.size.height);
            [UIView animateWithDuration:1/60.0 animations:^{
                self.BDScrollerView.contentOffset = CGPointMake(_regularTableView.frame.size.width, 0);
            }];
        });
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    istrueTimes=YES;
    isfirst=NO;
    isreflectFirst=NO;
    
    _finecurrentPage=1;
    _regularcurrentPage=1;
    
    if (_groupArray.count!=0) {
        [_groupArray removeAllObjects];
        if (_groupArraymore.count!=0) {
            [_groupArraymore removeAllObjects];
        }
    }
    if (_groupArrayregular.count!=0) {
        [_groupArrayregular removeAllObjects];
        if (_groupArraymoreregular.count!=0) {
            [_groupArraymoreregular removeAllObjects];
        }
    }
    
    [self requestbuy];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark- 请求买入接口
static bool isfirst=NO;
-(void)requestbuy
{
    NSLog(@"isfirst=%d",isfirst);
    // if (!isfirst) {
    [[BtmMobile shareBtmMoile]startMove:self];
    // }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]TransactionRecordsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] transType:0 pages:10 rows:_finecurrentPage];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMTransactionRecords_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        
        // 请求接口
        if (!isfirst) {
            [self requestreflect];
        }
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dictRecords=responsedict[@"data"];
            NSArray *array= [dictRecords allKeys];
            if ([[SYMPublicDictionary shareDictionary]judgeArray:array]) {
                [[BtmMobile shareBtmMoile]stopMove];
                [_fineSelectTableView.header endRefreshing];
                [_fineSelectTableView.footer endRefreshing];
                //[_fineSelectTableView.footer removeFromSuperview];
                if (!isfirst) {
                    isfirst=YES;
                    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                    [tabcontrol hidenTabBar:YES];
                    // 邀请码
                    BtmSharePinPassWordViewController *btmSPVc = [[BtmSharePinPassWordViewController alloc] init];
                    btmSPVc.isinput=isTransactionrecords;
                    [btmSPVc defaultStandPinPassword:self];
                    btmSPVc.backPassword = ^(NSString *password)
                    {
                    };
                    btmSPVc.close=^{
                        SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
                        [tabcontrol hidenTabBar:NO];
                    };
                    [self presentViewController:btmSPVc animated:NO completion:nil];
                }
                return;
            }
            
            if (_groupArraymore.count!=0) {
                BOOL isjugehave=NO;
                NSString *keyNames=[[NSString alloc]init];
                
                for (NSString *keyname in array){
                    for (int i=0;i<_groupArraymore.count;i++)  {
                        if ([_groupArraymore[i] isEqualToString:keyname]) {
                            isjugehave=YES;
                            // 这个名字组里面已经有了
                            NSArray *inforArray=dictRecords[keyname];
                            //NSMutableArray *_fineSelectArray=[[NSMutableArray alloc]init];
                            for (NSDictionary *dict in inforArray) {
                                TransactionRecords *transrecord=[[TransactionRecords alloc]init];
                                transrecord.orderId=dict[@"orderId"];
                                transrecord.businessType=dict[@"businessType"];
                                transrecord.transType=dict[@"transType"];
                                transrecord.status=dict[@"status"];
                                transrecord.spendTime=dict[@"spendTime"];
                                transrecord.amount=dict[@"amount"];
                                transrecord.publishName=dict[@"publishName"];
                                [_groupArray[i] addObject:transrecord];
                            }
                            // NSLog(@"_groupArray[i]==%@",_groupArray[i]);
                            
                        }else{
                            isjugehave=NO;
                            keyNames=keyname;
                        }
                    }
                    // 里面的循环结束
                    if (!isjugehave) {
                        [_groupArraymore addObject:keyNames]; // 给组添加值
                        NSArray *inforArray=dictRecords[keyNames];
                        NSMutableArray *_fineSelectArray=[[NSMutableArray alloc]init];
                        for (NSDictionary *dict in inforArray) {
                            TransactionRecords *transrecord=[[TransactionRecords alloc]init];
                            transrecord.orderId=dict[@"orderId"];
                            transrecord.businessType=dict[@"businessType"];
                            transrecord.transType=dict[@"transType"];
                            transrecord.status=dict[@"status"];
                            transrecord.spendTime=dict[@"spendTime"];
                            transrecord.amount=dict[@"amount"];
                            transrecord.publishName=dict[@"publishName"];
                            [_fineSelectArray addObject:transrecord];
                        }
                        [_groupArray addObject:_fineSelectArray];
                    }
                }
                
                if (!isfirst) { // 是第一次
                    isfirst=YES;
                }else{
                    
                    [_fineSelectTableView reloadData];
                    [[BtmMobile shareBtmMoile]stopMove];
                    [_fineSelectTableView.header endRefreshing];
                    [_fineSelectTableView.footer endRefreshing];
                }
                
            }else{
                _groupArraymore=[array mutableCopy]; // 给组赋值
                for (int i=0;i<_groupArraymore.count;i++) {
                    NSArray *inforArray=dictRecords[_groupArraymore[i]];
                    NSMutableArray *_fineSelectArray=[[NSMutableArray alloc]init];
                    for (NSDictionary *dict in inforArray) {
                        TransactionRecords *transrecord=[[TransactionRecords alloc]init];
                        transrecord.orderId=dict[@"orderId"];
                        transrecord.businessType=dict[@"businessType"];
                        transrecord.transType=dict[@"transType"];
                        transrecord.status=dict[@"status"];
                        transrecord.spendTime=dict[@"spendTime"];
                        transrecord.amount=dict[@"amount"];
                        transrecord.publishName=dict[@"publishName"];
                        [_fineSelectArray addObject:transrecord];
                    }
                    [_groupArray addObject:_fineSelectArray];
                }
                
                if (!isfirst) {
                    isfirst=YES;
                    
                }else{
                    [_fineSelectTableView reloadData];
                    [[BtmMobile shareBtmMoile]stopMove];
                    [_fineSelectTableView.header endRefreshing];
                    [_fineSelectTableView.footer endRefreshing];
                }
                
            }
        }
        
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        if (!isfirst) { // 第一次请求第二次不请求
            isfirst=YES;
            [self requestreflect];
        }else{
            [[BtmMobile shareBtmMoile]stopMove];
            [_fineSelectTableView.header endRefreshing];
            [_fineSelectTableView.footer endRefreshing];
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统异常" preferredStyle: UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
}

#pragma mark- 请求体现接口
static bool isreflectFirst=NO;
-(void)requestreflect
{
    if (isreflectFirst) {
        [[BtmMobile shareBtmMoile]startMove:self];
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]TransactionRecordsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] transType:1 pages:10 rows:_regularcurrentPage];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMTransactionRecords_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"flectresponseObj-->%@",responsedict);
        if (!isreflectFirst) {
            [[BtmMobile shareBtmMoile]stopMove];
        }
        
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dictRecords=responsedict[@"data"];
            NSArray *array= [dictRecords allKeys];
            if ([[SYMPublicDictionary shareDictionary]judgeArray:array]) {
                if (isreflectFirst) {
                    [[BtmMobile shareBtmMoile]stopMove];
                    [_regularTableView.header endRefreshing];
                    [_regularTableView.footer endRefreshing];
                }
                //[_regularTableView.footer removeFromSuperview];
                return ;
            }
            // 修改代码
            if (_groupArraymoreregular.count!=0) {
                BOOL isjugehavemore=NO;
                NSString *keyNamesmore=[[NSString alloc]init];
                
                for (NSString *keyname in array){
                    for (int i=0;i<_groupArraymoreregular.count;i++)  {
                        if ([_groupArraymoreregular[i] isEqualToString:keyname]) {
                            isjugehavemore=YES;
                            // 这个名字组里面已经有了
                            NSArray *inforArray=dictRecords[keyname];
                            //NSMutableArray *_fineSelectArray=[[NSMutableArray alloc]init];
                            NSLog(@"_groupArrayregular=%lu",(unsigned long)_groupArrayregular.count);
                            for (NSDictionary *dict in inforArray) {
                                TransactionRecords *transrecord=[[TransactionRecords alloc]init];
                                transrecord.orderId=dict[@"orderId"];
                                transrecord.businessType=dict[@"businessType"];
                                transrecord.transType=dict[@"transType"];
                                transrecord.status=dict[@"status"];
                                transrecord.spendTime=dict[@"spendTime"];
                                transrecord.amount=dict[@"amount"];
                                transrecord.publishName=dict[@"publishName"];
                                [_groupArrayregular[i] addObject:transrecord];
                            }
                            NSLog(@"_groupArray[i]==%@",_groupArrayregular[i]);
                            
                        }else{
                            isjugehavemore=NO;
                            keyNamesmore=keyname;
                        }
                    }
                    // 里面的循环结束
                    if (!isjugehavemore) {
                        [_groupArraymoreregular addObject:keyNamesmore]; // 给组添加值
                        NSArray *inforArray=dictRecords[keyNamesmore];
                        NSMutableArray *_fineSelectArray=[[NSMutableArray alloc]init];
                        for (NSDictionary *dict in inforArray) {
                            TransactionRecords *transrecord=[[TransactionRecords alloc]init];
                            transrecord.orderId=dict[@"orderId"];
                            transrecord.businessType=dict[@"businessType"];
                            transrecord.transType=dict[@"transType"];
                            transrecord.status=dict[@"status"];
                            transrecord.spendTime=dict[@"spendTime"];
                            transrecord.amount=dict[@"amount"];
                            transrecord.publishName=dict[@"publishName"];
                            [_fineSelectArray addObject:transrecord];
                        }
                        
                        [_groupArrayregular addObject:_fineSelectArray];
                    }
                }
                
                [_regularTableView reloadData];
                if (!isreflectFirst) {
                    isreflectFirst=YES;
                    [_fineSelectTableView reloadData];
                    [[BtmMobile shareBtmMoile]stopMove];
                }else{
                    [[BtmMobile shareBtmMoile]stopMove];
                    [_regularTableView.header endRefreshing];
                    [_regularTableView.footer endRefreshing];
                }
                
                
            }else{
                _groupArraymoreregular=[array mutableCopy]; // 给组赋值
                for (int i=0;i<_groupArraymoreregular.count;i++) {  // _groupArraymoreregular _groupArraymore
                    NSArray *inforArray=dictRecords[_groupArraymoreregular[i]];
                    NSMutableArray *_fineSelectArray=[[NSMutableArray alloc]init];
                    for (NSDictionary *dict in inforArray) {
                        TransactionRecords *transrecord=[[TransactionRecords alloc]init];
                        transrecord.orderId=dict[@"orderId"];
                        transrecord.businessType=dict[@"businessType"];
                        transrecord.transType=dict[@"transType"];
                        transrecord.status=dict[@"status"];
                        transrecord.spendTime=dict[@"spendTime"];
                        transrecord.amount=dict[@"amount"];
                        transrecord.publishName=dict[@"publishName"];
                        [_fineSelectArray addObject:transrecord];
                    }
                    [_groupArrayregular addObject:_fineSelectArray];
                }
                [_regularTableView reloadData];
                if (!isreflectFirst) {
                    isreflectFirst=YES;
                    [_fineSelectTableView reloadData];
                    [[BtmMobile shareBtmMoile]stopMove];
                }else{
                    [[BtmMobile shareBtmMoile]stopMove];
                    [_regularTableView.header endRefreshing];
                    [_regularTableView.footer endRefreshing];
                }
                
            }
        }
        
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        if (!isreflectFirst) {
            isreflectFirst=YES;
            [[BtmMobile shareBtmMoile]stopMove];
        }else{
            [[BtmMobile shareBtmMoile]stopMove];
            [_regularTableView.header endRefreshing];
            [_regularTableView.footer endRefreshing];
        }
        
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统异常" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }];
}

#pragma mark- 循环交易状态
-(NSString *)filterTransactionstatus:(NSString *)status
{
    NSString *inforStatus=[[NSString alloc]init];
    switch ([status intValue]) {
        case 0:
        {
            inforStatus=@"交易下单";
        }
            break;
        case 1:
        {
            inforStatus=@"交易处理中";
        }
            break;
        case 2:
        {
            inforStatus=@"交易成功";
        }
            break;
        case 3:
        {
            inforStatus=@"交易撤单";
        }
            break;
        case 4:
        {
            inforStatus=@"交易结束";
        }
            break;
        case 5:
        {
            inforStatus=@"交易失败";
        }
            break;
            
        default:
            break;
    }
    return inforStatus;
}

#pragma mark- 时间戳转化
-(NSString *)getNowDate:(NSString *)nowdate
{
    NSString *time=[[NSString stringWithFormat:@"%@",nowdate] substringToIndex:10];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    // NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    // NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

#pragma mark- 刷新加载更多
-(void)dofineHeaderRefresh//刷新
{
    
    if (_groupArray.count!=0) {
        [_groupArray removeAllObjects];
        if (_groupArraymore.count!=0) {
            [_groupArraymore removeAllObjects];
        }
        _finecurrentPage=1;
        [self requestbuy];
    }else{
        
        _finecurrentPage=1;
        [self requestbuy];
    }
}

-(void)doregularfineHeaderRefresh//刷新
{
    if (_groupArrayregular.count!=0) {
        [_groupArrayregular removeAllObjects];
        if (_groupArraymoreregular.count!=0) {
            [_groupArraymoreregular removeAllObjects];
        }
        _regularcurrentPage=1;
        [self requestreflect];
    }else{
        _regularcurrentPage=1;
        [self requestreflect];
    }
}

-(void)dofineFooterRefresh
{
    _finecurrentPage ++;
    [self requestbuy];
}

-(void)doregularFooterRefresh
{
    _regularcurrentPage ++;
    [self requestreflect];
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

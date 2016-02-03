//
//  SYMAssetRegularFinancialViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/24.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMAssetRegularFinancialViewController.h"
#import "SYMConstantCenter.h"
#import "SYMFinancialRegularTableViewCell.h"
#import "SYMFinancialRegularMoreTableViewCell.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "LoginViewController.h"
#import "SYMDataBaseModel.h"
#import "SYMTabController.h"
#import "SYMNewAssetReflectViewController.h"
#import "MyTipsWindow.h"

@interface SYMAssetRegularFinancialViewController ()<UIScrollViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    NSMutableArray *_dataArray;
    UILabel *EarningsMoneys;
    UILabel *EarningsMoney;
    //    NSString * statuscustom;
    NSString *_expireProcessMode;
    BOOL isChangestatus;
    NSMutableArray *_savestateArray;
}
@end

@implementation SYMAssetRegularFinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray=[[NSMutableArray alloc]init];
    _savestateArray=[[NSMutableArray alloc]init];
    [self initNavigationView];
    self.BDTableView.tableFooterView=[[UIView alloc]init];
    self.BDTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initShuffling];
    
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"定期理财";
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

-(void)initShuffling
{
    CGFloat imageY=0;
    CGFloat imageW=BTMWidth;
    //*SYMWIDthRATESCALE;
    CGFloat imageH=0;
    //self.HeaderScrollerView.frame.size.height;
    //*SYMHEIGHTRATESCALE;
    //用for循环往ScrollView中添加图片，这里面计算每张图片的x值是重点
    for (int i=0; i<2; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView setBackgroundColor:[UIColor colorWithRed:66/255.0f green:170/255.0f blue:229/255.0f alpha:1]];
        imageView.userInteractionEnabled=YES;
        CGFloat imageX=i*imageW;
        imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
        [self.HeaderScrollerView addSubview:imageView];
        
        if (i==0) {
            EarningsMoneys=[[UILabel alloc]init];
            EarningsMoneys.text=@"300.45";
            EarningsMoneys.font=[UIFont systemFontOfSize:36.0];
            EarningsMoneys.textColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
            [imageView addSubview:EarningsMoneys];
            
            EarningsMoneys.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsMoneys attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:34]];
            
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsMoneys attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            
            UILabel *EarningsNames=[[UILabel alloc]init];
            EarningsNames.text=@"总资产(元)";
            EarningsNames.font=[UIFont systemFontOfSize:12.0];
            EarningsNames.textColor=[UIColor colorWithRed:192/255.0f green:232/255.0f blue:254/255.0f alpha:1];
            [imageView addSubview:EarningsNames];
            
            EarningsNames.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsNames attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:80]];
            
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsNames attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            //[imageView setBackgroundColor:[UIColor blueColor]];
        }else{
            EarningsMoney=[[UILabel alloc]init];
            EarningsMoney.text=@"400.95";
            EarningsMoney.font=[UIFont systemFontOfSize:36.0];
            EarningsMoney.textColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
            [imageView addSubview:EarningsMoney];
            
            EarningsMoney.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsMoney attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:34]];
            
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsMoney attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            
            UILabel *EarningsName=[[UILabel alloc]init];
            EarningsName.text=@"预期收益(元)";
            EarningsName.font=[UIFont systemFontOfSize:12.0];
            EarningsName.textColor=[UIColor colorWithRed:192/255.0f green:232/255.0f blue:254/255.0f alpha:1];
            [imageView addSubview:EarningsName];
            
            EarningsName.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:80]];
            
            [imageView addConstraint:[NSLayoutConstraint constraintWithItem:EarningsName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        }
    }
    self.HeaderScrollerView.contentSize=CGSizeMake(2*imageW, imageH);
    self.HeaderScrollerView.delegate=self;
    self.PageControlS.numberOfPages=2;
    self.PageControlS.currentPage=0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView==self.HeaderScrollerView) {
        //计算滚到了第几页
        int currpage = scrollView.contentOffset.x/BTMWidth;
        NSLog(@"curr = %d",currpage);
        self.PageControlS.currentPage = currpage;
        if (currpage==0) {
            scrollView.contentOffset=CGPointMake(0, 0);
        }else{
            scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, 0);
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146*SYMHEIGHTRATESCALE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static NSString *identity=@"cell";
    SYMFinancialRegularMoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMFinancialRegularMoreTableViewCell" owner:self options:nil]lastObject];
    }
    if (_dataArray.count!=0) {
        
        RegularBasisList *model=_dataArray[indexPath.row];
        if (![[NSString stringWithFormat:@"%@",model.isInvestAgain] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"2"]) {
            cell.Rightwidth.constant=0;
            [cell.Switch setHidden:YES];
            [cell.endTime setHidden:YES];
            if ([[NSString stringWithFormat:@"%@",model.isHonor] isEqualToString:@"1"] &&[[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"4"] ) {
                [cell.endTime setHidden:NO];
                cell.endTime.text=@"到期已提现";
            }else if([[NSString stringWithFormat:@"%@",model.isHonor] isEqualToString:@"0"] &&[[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"4"]){
                [cell.endTime setHidden:NO];
                cell.endTime.text=@"到期未提现";
            }
            
        }else{
            
            if ([[NSString stringWithFormat:@"%@",model.isHonor] isEqualToString:@"1"] &&[[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"4"] ) {
                cell.Rightwidth.constant=0;
                [cell.endTime setHidden:NO];
                [cell.Switch setHidden:YES];
                cell.endTime.text=@"到期已提现";
            }else if([[NSString stringWithFormat:@"%@",model.isHonor] isEqualToString:@"0"] &&[[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"4"]){
                cell.Rightwidth.constant=0;
                [cell.endTime setHidden:NO];
                [cell.Switch setHidden:YES];
                cell.endTime.text=@"到期未提现";
            }
        }
        
        //        if ([[self intervalSinceNow:model.redemptionTime] intValue]<=-3) {
        //
        //        }else{
        //            NSLog(@"日期过期");
        //            //[[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"产品到期前三天不可修改" backgroundcolor:white];
        //            cell.Switch.enabled=NO;
        //        }
        
        cell.ProductName.text=[NSString stringWithFormat:@"%@",model.publishName];
        cell.buyInMoney.text=[NSString stringWithFormat:@"%@",model.amount];
        cell.Interestdue.text=[NSString stringWithFormat:@"%@",model.expctedEarning];
        cell.Duetime.text=[self getNowDate:model.redemptionTime];
        
        // 滑块代码
        cell.Switch.arrange = CustomSwitchArrangeONLeftOFFRight;
        cell.Switch.onImage = [UIImage imageNamed:@"huakuang-lan54"];
        cell.Switch.offImage = [UIImage imageNamed:@"huakuang-cheng54"];
        cell.Switch.tag=indexPath.row;
        
        
        //                cell.Switch.onImage = [UIImage imageNamed:@"huakuang-daoqi"];
        //                cell.Switch.offImage = [UIImage imageNamed:@"huakuang-daoqi"];
        //                cell.Switch.enabled=NO;
        
        NSLog(@"index=%ld",(long)indexPath.row);
        
        if (_savestateArray.count!=0) {
            for (NSString *indexTag in _savestateArray) {
                if ([indexTag longLongValue] == indexPath.row) {
                    
                    if ([[NSString stringWithFormat:@"%@",model.expireProcessMode] isEqualToString:@"1"]) {
                        
                        cell.Switch.status = CustomSwitchStatusOff;
                        //CustomSwitchStatusOff; // 续投
                    }else{
                        cell.Switch.status = CustomSwitchStatusOn;
                        //CustomSwitchStatusOn;  // 赎回
                    }
                }
            }
        }else{
            if ([[NSString stringWithFormat:@"%@",model.expireProcessMode] isEqualToString:@"1"]) {
                
                cell.Switch.status = CustomSwitchStatusOff; // 续投
            }else{
                cell.Switch.status = CustomSwitchStatusOn;  // 赎回
            }
        }
        
        
        //        cell.Switch.onImage = [UIImage imageNamed:@"huakuang-daoqi54"];
        //        cell.Switch.offImage = [UIImage imageNamed:@"huakuang-daoqi54"];
        //        cell.Switch.enabled=NO;
    }
    // cell 不可以选中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - customSwitch delegate
-(void)customSwitchSetStatus:(CustomSwitchStatus)status switch:(UIControl *)switchbtn
{
    CustomSwitch *switchcustom=(CustomSwitch *)switchbtn;
    NSLog(@"switchcustom.tag=%ld",(long)switchcustom.tag);
    if (_dataArray.count!=0) {
        RegularBasisList *regularList=_dataArray[switchcustom.tag];
        NSLog(@"regularList.expireProcessMode=%@",regularList.expireProcessMode);
        NSLog(@"status=%ld",(unsigned long)status);
        if (![[NSString stringWithFormat:@"%@",regularList.expireProcessMode] isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)status]]) {
            
            if ([[self intervalSinceNow:regularList.redemptionTime] intValue]<=-3) {
                
                [self requestinves:regularList.orderId expireProcessMode:[NSString stringWithFormat:@"%lu",(unsigned long)status] CustomSwitch:switchcustom];
                switch (status) {
                    case CustomSwitchStatusOn:
                    {
                        NSLog(@"赎回");
                        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"您已将到期状态修改为到期提现到账号中" backgroundcolor:white];
                    }
                        break;
                    case CustomSwitchStatusOff:
                    {
                        NSLog(@"续投");
                        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"您已将到期状态修改为到期后续投" backgroundcolor:white];
                    }
                        break;
                    default:
                        break;
                }
                
            }else{
                if (status==CustomSwitchStatusOn) {
                    switchcustom.status=CustomSwitchStatusOff;
                }else if (status==CustomSwitchStatusOff)
                {
                    switchcustom.status=CustomSwitchStatusOn;
                }
                NSLog(@"日期过期");
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"产品到期前三天不可修改" backgroundcolor:white];
            }
        }else{
            
            if (_savestateArray.count!=0) {
                for (NSString *indexTag in _savestateArray) {
                    if ([indexTag longLongValue] == switchcustom.tag) {
                        
                        if ([[self intervalSinceNow:regularList.redemptionTime] intValue]<=-3) {
                            
                            [self requestinves:regularList.orderId expireProcessMode:[NSString stringWithFormat:@"%lu",(unsigned long)status] CustomSwitch:switchcustom];
                            switch (status) {
                                case CustomSwitchStatusOn:
                                {
                                    NSLog(@"赎回");
                                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"您已将到期状态修改为到期提现到账号中" backgroundcolor:white];
                                }
                                    break;
                                case CustomSwitchStatusOff:
                                {
                                    NSLog(@"续投");
                                    [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"您已将到期状态修改为到期后续投" backgroundcolor:white];
                                }
                                    break;
                                default:
                                    break;
                            }
                            
                        }else{
                            if (status==CustomSwitchStatusOn) {
                                switchcustom.status=CustomSwitchStatusOff;
                            }else if (status==CustomSwitchStatusOff)
                            {
                                switchcustom.status=CustomSwitchStatusOn;
                            }
                            NSLog(@"日期过期");
                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"产品到期前三天不可修改" backgroundcolor:white];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark- 续投状态
-(void)requestinves:(NSString *)orderid expireProcessMode:(NSString *)expireProcessMode CustomSwitch:(CustomSwitch *)switchcustom
{
    //if (isChangestatus) {
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]InvestmentOrRedeemPublicDictnary:orderid expireProcessMode:expireProcessMode];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMregularMoneyInvestmentOrRedeem_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegularFinancialresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            //isChangestatus=YES;
            if (_savestateArray.count!=0) {
                for (NSString  *indexTag in _savestateArray) {
                    if ([indexTag longLongValue]==(long)switchcustom.tag) {
                        
                        [_savestateArray removeObject:[NSString stringWithFormat:@"%ld",(long)switchcustom.tag]];
                    }else{
                        [_savestateArray addObject:[NSString stringWithFormat:@"%ld",(long)switchcustom.tag]];
                    }
                }
            }else{
                [_savestateArray addObject:[NSString stringWithFormat:@"%ld",(long)switchcustom.tag]];
            }
            
            // NSLog(@"switchcustom.tag=%ld",(long)switchcustom.tag);
            // [self requestRegularFinancial];
            
        }else{
            //switchcustom.enabled=NO;
            if ([expireProcessMode isEqualToString:@"1"]) {
                switchcustom.status=0;
            }else{
                switchcustom.status=1;
            }
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
    // }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.emptyData setHidden:YES];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    [self requestRegularFinancial];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:NO];
}

#pragma mark- 请求定期理财
-(void)requestRegularFinancial
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]MyAssetsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMRegularbasisFinancial_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegularFinancialresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dict=responsedict[@"data"];
            EarningsMoneys.text=[NSString stringWithFormat:@"%@",dict[@"fixedTotalAssets"]];
            EarningsMoney.text=[NSString stringWithFormat:@"%@",dict[@"expectedIncome"]];
            self.ReflectBalance.text=[NSString stringWithFormat:@"%@",dict[@"cashMoney"]];
            NSArray *arrlist=dict[@"orderList"];
            BOOL isc=[[SYMPublicDictionary shareDictionary]judgeArray:arrlist];
            if (!isc) {
                for (NSDictionary *dictlist in arrlist) {
                    RegularBasisList *regularList=[[RegularBasisList alloc]init];
                    regularList.publishCode=dictlist[@"publishCode"];
                    regularList.publishName=dictlist[@"publishName"];
                    regularList.productCode=dictlist[@"productCode"];
                    regularList.expctedEarning=dictlist[@"expctedEarning"];
                    regularList.expireProcessMode=dictlist[@"expireProcessMode"];
                    regularList.amount=dictlist[@"amount"];
                    regularList.redemptionTime=dictlist[@"redemptionTime"];
                    regularList.isInvestAgain=dictlist[@"isInvestAgain"];
                    regularList.status=dictlist[@"status"];
                    regularList.isHonor=dictlist[@"isHonor"];
                    regularList.orderId=dictlist[@"orderId"];
                    [_dataArray addObject:regularList];
                }
                [self.BDTableView reloadData];
            }else{
                [self.emptyData setHidden:NO];
            }
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 时间戳转化
-(NSString *)getNowDate:(NSString *)nowdate
{
    NSString *time=[[NSString stringWithFormat:@"%@",nowdate] substringToIndex:10];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"]; // yyyy-MM-dd hh:mm:ss
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

#pragma mark ----计算时间差
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    // 时间戳转成时间
    NSString *parmtime=  [self getNowDate:theDate];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *d=[date dateFromString:parmtime];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"0";
    
    NSTimeInterval cha=now-late;
    
    //    if (cha/3600<1) {
    //
    //        NSLog(@"========================================计算时间");
    //
    //        timeString = [NSString stringWithFormat:@"%f", cha/60];
    //        timeString = [timeString substringToIndex:timeString.length-7];
    //        //timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    //
    //    }
    
    
    //            if (cha/3600>1&&cha/86400<1) {
    //                timeString = [NSString stringWithFormat:@"%f", cha/3600];
    //                timeString = [timeString substringToIndex:timeString.length-7];
    //               // timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    //            }
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        // timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }else{
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
    }
    
    NSLog(@"--------->多少天前=%@",timeString);
    return timeString;
}


-(void)tapBack:(UITapGestureRecognizer *) tap{
    
    NSLog(@"");
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
#pragma mark- 提现
- (IBAction)BtnClick:(id)sender {
    if ([self.ReflectBalance.text doubleValue]<=0) {
        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"可提现金额为0元" backgroundcolor:white];
    }else{
        SYMNewAssetReflectViewController *flectControl=[[SYMNewAssetReflectViewController alloc]initWithNibName:@"SYMNewAssetReflectViewController" bundle:nil];
        [self.navigationController pushViewController:flectControl animated:YES];
    }
}
@end

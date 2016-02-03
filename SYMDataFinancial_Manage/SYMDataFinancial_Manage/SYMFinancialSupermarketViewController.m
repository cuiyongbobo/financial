//
//  SYMFinancialSupermarketViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "SYMFinancialSupermarketViewController.h"
#import "SYMConstantCenter.h"
#import "SYMSupermarketRegularTableViewCell.h"
#import "SYMChoicenessStyleTableViewCell.h"
#import "SYMChoicenessStyleMoreTableViewCell.h"
#import "RegularProductDetailsViewController.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "ZplayNoject.h"
#import "BtmMobile.h"

@interface SYMFinancialSupermarketViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_fineSelectTableView;
    UITableView *_regularTableView;
    UIImageView *_TitleImage;
    UILabel     *companyAccount;
    NSMutableArray *_fineSelectArray;
    NSMutableArray *_regularArray;
    UIButton *buttonregular;
    UIButton *buttonselect;
    ProductList *_productModel;
    NSString *_showbtnText;
}
@end

@implementation SYMFinancialSupermarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    [self initViews];
    
    _fineSelectTableView.tableFooterView=[[UIView alloc]init];
    _regularTableView.tableFooterView=[[UIView alloc]init];
    _regularTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _fineSelectTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [_regularTableView setBackgroundColor:SYMBDClolor];
    [_fineSelectTableView setBackgroundColor:SYMBDClolor];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    // 定义Navigation的titleView
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""]; // toubuhuakuang_weixuanzhong
    _TitleImage.userInteractionEnabled=YES;
    self.navigationItem.titleView=_TitleImage;
    
    buttonselect=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonselect.frame=CGRectMake(0, 0, _TitleImage.frame.size.width/2, _TitleImage.frame.size.height);
    buttonselect.tag=200;
    [buttonselect setTitle:@"精选" forState:UIControlStateNormal];
    [buttonselect setBackgroundImage:[UIImage imageNamed:@"huakuang-xuanzhong-left"]forState:UIControlStateNormal];
    [buttonselect setTitleColor:SYMBLUECOLOR forState:UIControlStateNormal];
    buttonselect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonselect addTarget:self action:@selector(changebtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TitleImage addSubview:buttonselect];
    
    buttonregular=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonregular.frame=CGRectMake(buttonselect.frame.size.width, 0, _TitleImage.frame.size.width/2, _TitleImage.frame.size.height);
    buttonregular.tag=201;
    [buttonregular setTitle:@"定期" forState:UIControlStateNormal];
    [buttonregular setBackgroundImage:[UIImage imageNamed:@"huakuang-buxuan-right"]forState:UIControlStateNormal];
    [buttonregular setTitleColor:SYMFontColor forState:UIControlStateNormal];
    buttonregular.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [buttonregular addTarget:self action:@selector(changebtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_TitleImage addSubview:buttonregular];
}

-(void)changebtnClick:(UIButton *)button
{
    if (button.tag==200) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonregular setBackgroundImage:[UIImage imageNamed:@"huakuang-buxuan-right"]forState:UIControlStateNormal];
            [buttonregular setTitleColor:SYMFontColor forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"huakuang-xuanzhong-left"]forState:UIControlStateNormal];
            [button setTitleColor:SYMBLUECOLOR forState:UIControlStateNormal];
            // 精选
            _fineSelectTableView.frame = CGRectMake(_fineSelectTableView.frame.origin.x, _fineSelectTableView.frame.origin.y, _fineSelectTableView.frame.size.width,_fineSelectTableView.frame.size.height);
            [UIView animateWithDuration:1/60.0 animations:^{
                self.BDScrollView.contentOffset = CGPointMake(0, 0);
            }];
        });
        // 定期
    }else if (button.tag==201){
        dispatch_async(dispatch_get_main_queue(), ^{
            [buttonselect setBackgroundImage:[UIImage imageNamed:@"huakuang-buxuan-left"]forState:UIControlStateNormal];
            [buttonselect setTitleColor:SYMFontColor forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"huakuang-xuanzhong-right"]forState:UIControlStateNormal];
            [button setTitleColor:SYMBLUECOLOR forState:UIControlStateNormal];
            _regularTableView.frame = CGRectMake(_regularTableView.frame.origin.x, _regularTableView.frame.origin.y, _regularTableView.frame.size.width,_regularTableView.frame.size.height);
            [UIView animateWithDuration:1/60.0 animations:^{
                self.BDScrollView.contentOffset = CGPointMake(_regularTableView.frame.size.width, 0);
            }];
        });
    }
}

-(void)initViews
{
    _fineSelectArray = [[NSMutableArray alloc] init];
    _regularArray    = [[NSMutableArray alloc] init];
    CGFloat width = BTMWidth;
    CGFloat height =BTMHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    _fineSelectTableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height-120*SYMHEIGHTRATESCALE) style:UITableViewStylePlain];
    _fineSelectTableView.delegate = self;
    _fineSelectTableView.dataSource = self;
    [self.BDScrollView addSubview:_fineSelectTableView];
    
    x = width;
    height =_fineSelectTableView.frame.size.height;
    _regularTableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, width, height) style:UITableViewStylePlain];
    _regularTableView.delegate = self;
    _regularTableView.dataSource = self;
    [self.BDScrollView addSubview:_regularTableView];
    
    self.BDScrollView.contentSize = CGSizeMake(width*2, self.BDScrollView.contentSize.height);
    self.BDScrollView.pagingEnabled = YES;
    self.BDScrollView.bounces = NO;
    self.BDScrollView.showsHorizontalScrollIndicator = NO;
    self.BDScrollView.showsVerticalScrollIndicator = NO;
    self.BDScrollView.delegate =self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        if (_regularArray.count!=0) {
            [_regularArray removeAllObjects];
        }
        if (_fineSelectArray.count!=0) {
            [_fineSelectArray removeAllObjects];
        }

        if ([self isMainhaveNetwork]) {
            [self requestProductList];
        }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [[BtmMobile shareBtmMoile]stopMove];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _fineSelectTableView) {
        return 1;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _fineSelectTableView) {
        return _fineSelectArray.count;
    }else if (tableView==_regularTableView){
        return _regularArray.count;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_fineSelectTableView) {
        return OTHERADDRESSTABLEVIEWCELL_HEIGHT;
    }else if (tableView==_regularTableView){
        return RegularTABLEVIEWCELL_HEIGHT;
    }else{
        return 0;
    }
}

// 设置组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _fineSelectTableView) {
        return 0;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_regularTableView) {
        // if (_regularArray.count!=0) {
        
        // 定期产品
        static NSString *identity=@"cell";
        SYMSupermarketRegularTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMSupermarketRegularTableViewCell" owner:self options:nil]lastObject];
        }
        if (_regularArray.count!=0) {
            _productModel=_regularArray[indexPath.row];
            
            cell.YearYield.text=[NSString stringWithFormat:@"%@",_productModel.standardProfit];;
            cell.RemainMoney.text=[NSString stringWithFormat:@"%@",_productModel.remaining];
            cell.Limit.text=[NSString stringWithFormat:@"%@",_productModel.period];
            cell.LimitTime.text=[NSString stringWithFormat:@"%@",[self matchLimtTime:_productModel.unit]];
            cell.ProductName.text=[NSString stringWithFormat:@"%@",_productModel.productName];
            
            // 分销收益-已经加上扩展收益了
            double Calculatetotal=[[NSString stringWithFormat:@"%@",_productModel.expandProfit] doubleValue];
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:ISdistribution] isEqualToString:@"1"]) {
                Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
                
            }else{
                // 新老用户
                NSString *usertypeinfor=[[NSUserDefaults standardUserDefaults]objectForKey:UserType];
                BOOL isc=[[SYMPublicDictionary shareDictionary]judgeString:usertypeinfor];
                if (!isc) {
                    if ([usertypeinfor isEqualToString:[NSString stringWithFormat:@"%@",_productModel.purchaserType]]) {
                        Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.purchaserProfit] doubleValue];
                    }
                }
            }
            //Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
            NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
            // 终端收益
            BOOL c=[[SYMPublicDictionary shareDictionary]judgeString:userId];
            if (c) {
                Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.terminalProfit] doubleValue];
            }
            
            cell.AdditionalBenefitLabel.text=[NSString stringWithFormat:@"%.2f",Calculatetotal];
            if (Calculatetotal==0) {
                [cell.AdditionalBenefitLabel setHidden:YES];
                [cell.additionalImageView setHidden:YES];
                [cell.addLabel setHidden:YES];
                cell.Leftwidth.constant=15*SYMWIDthRATESCALE;
            }
            
            BOOL b=[[SYMPublicDictionary shareDictionary] judgeString:_productModel.TagName];
            
            if (!b) {
                [cell.ShowLabelImageview setHidden:NO];
                cell.LabelName.text=[NSString stringWithFormat:@"%@",_productModel.TagName];
            }else{
                [cell.ShowLabelImageview setHidden:YES];
                [cell.LabelName setHidden:YES];
            }
            
            BOOL isb=[self statusbtnType:_productModel.sellStatus isstatus:YES];
            if (isb) {
                // 售完了
                cell.MakeMoney.selected=NO;
                [cell.MakeMoney setTitle:_showbtnText forState:UIControlStateNormal];
                [cell.MakeMoney setBackgroundImage:[UIImage imageNamed:@"licaichaoshi-btn-hui"] forState:UIControlStateNormal];
            }else{
                [cell.MakeMoney setTitle:_showbtnText forState:UIControlStateNormal];
                [cell.MakeMoney addTarget:self action:@selector(MakeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.MakeMoney.tag=402;
            }
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        // }else{
        //     return nil;
        // }
    }else if (tableView==_fineSelectTableView){
        
        // if (_fineSelectArray.count!=0) {
        
        if (![[NSString stringWithFormat:@"%@",_productModel.productType] isEqualToString:@"1"]) {
            // 定期产品
            static NSString *identitySelect = @"cell";
            SYMChoicenessStyleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identitySelect];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMChoicenessStyleTableViewCell" owner:self options:nil]lastObject];
            }
            if (_fineSelectArray.count!=0) {
                _productModel=_fineSelectArray[indexPath.row];
                NSLog(@"name=%@",_productModel.productName);
                NSLog(@"tag.name=%@",_productModel.TagName);
                cell.AnnualEarnings.text=[NSString stringWithFormat:@"%@",_productModel.standardProfit];;
                cell.Balance.text=[NSString stringWithFormat:@"%@",_productModel.remaining];
                cell.TimeLimit.text=[NSString stringWithFormat:@"%@",_productModel.period];
                cell.TimeUnit.text=[NSString stringWithFormat:@"%@",[self matchLimtTime:_productModel.unit]];
                cell.ProductName.text=[NSString stringWithFormat:@"%@",_productModel.productName];
                
                // 分销收益-已经加上扩展收益了
                double Calculatetotal=[[NSString stringWithFormat:@"%@",_productModel.expandProfit] doubleValue];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:ISdistribution] isEqualToString:@"1"]) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
                    
                }else{
                    // 新老用户
                    NSString *usertypeinfor=[[NSUserDefaults standardUserDefaults]objectForKey:UserType];
                    BOOL isc=[[SYMPublicDictionary shareDictionary]judgeString:usertypeinfor];
                    if (!isc) {
                        if ([usertypeinfor isEqualToString:[NSString stringWithFormat:@"%@",_productModel.purchaserType]]) {
                            Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.purchaserProfit] doubleValue];
                        }
                    }
                }
                //Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
                NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
                // 终端收益
                BOOL c=[[SYMPublicDictionary shareDictionary]judgeString:userId];
                if (c) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.terminalProfit] doubleValue];
                }
                
                cell.AdditionalBenefitLabel.text=[NSString stringWithFormat:@"%.2f",Calculatetotal];
                if (Calculatetotal==0) {
                    [cell.AdditionalBenefitLabel setHidden:YES];
                    [cell.additionalImageView setHidden:YES];
                    [cell.addLabel setHidden:YES];
                    cell.Leftwidth.constant=20*SYMWIDthRATESCALE;
                }
                
                BOOL b=[[SYMPublicDictionary shareDictionary] judgeString:_productModel.TagName];
                
                if (!b) {
                    [cell.ShowLabelImageview setHidden:NO];
                    cell.LabelName.text=[NSString stringWithFormat:@"%@",_productModel.TagName];
                }else{
                    [cell.ShowLabelImageview setHidden:YES];
                    [cell.LabelName setHidden:YES];
                }
                
                BOOL isb=[self statusbtnType:_productModel.sellStatus isstatus:NO];
                if (isb) {
                    // 售完了
                    cell.MakeMoney.selected=NO;
                    [cell.MakeMoney setTitle:_showbtnText forState:UIControlStateNormal];
                    [cell.MakeMoney setBackgroundImage:[UIImage imageNamed:@"licaichaoshi-btn-hui"] forState:UIControlStateNormal];
                }else{
                    [cell.MakeMoney setTitle:_showbtnText forState:UIControlStateNormal];
                    [cell.MakeMoney addTarget:self action:@selector(MakeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.MakeMoney.tag=400;
                }
                
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            
            // 活期产品
            static NSString *identitySelects = @"cell";
            SYMChoicenessStyleMoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identitySelects];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SYMChoicenessStyleMoreTableViewCell" owner:self options:nil]lastObject];
            }
            if (_fineSelectArray.count!=0) {
                _productModel=_fineSelectArray[indexPath.row];
                
                cell.ProductName.text=[NSString stringWithFormat:@"%@",_productModel.productName];
                cell.AnnualEarnings.text=[NSString stringWithFormat:@"%@",_productModel.standardProfit];
                
                // 分销收益-已经加上扩展收益了
                double Calculatetotal=[[NSString stringWithFormat:@"%@",_productModel.expandProfit] doubleValue];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:ISdistribution] isEqualToString:@"1"]) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
                    
                }else{
                    // 新老用户
                    NSString *usertypeinfor=[[NSUserDefaults standardUserDefaults]objectForKey:UserType];
                    BOOL isc=[[SYMPublicDictionary shareDictionary]judgeString:usertypeinfor];
                    if (!isc) {
                        if ([usertypeinfor isEqualToString:[NSString stringWithFormat:@"%@",_productModel.purchaserType]]) {
                            Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.purchaserProfit] doubleValue];
                        }
                    }
                }
                //Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.isdistribute] doubleValue];
                NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
                // 终端收益
                BOOL c=[[SYMPublicDictionary shareDictionary]judgeString:userId];
                if (c) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",_productModel.terminalProfit] doubleValue];
                }
                
                cell.AdditionalBenefitLabel.text=[NSString stringWithFormat:@"%.2f",Calculatetotal];
                if (Calculatetotal==0) {
                    [cell.AdditionalBenefitLabel setHidden:YES];
                    [cell.additionalImageView setHidden:YES];
                    [cell.addLabel setHidden:YES];
                    cell.Leftwidth.constant=15*SYMWIDthRATESCALE;
                    cell.Centerwidth.constant=0;
                }
                
                
                BOOL b=[[SYMPublicDictionary shareDictionary] judgeString:_productModel.TagName];
                if (!b) {
                    [cell.ShowLabelImageview setHidden:NO];
                    cell.LabelName.text=[NSString stringWithFormat:@"%@",_productModel.TagName];
                }else{
                    [cell.ShowLabelImageview setHidden:YES];
                    [cell.LabelName setHidden:YES];
                }
                
                BOOL isb=[self statusbtnType:_productModel.sellStatus isstatus:NO];
                if (isb) {
                    // 售完了
                    cell.MakeMoney.selected=NO;
                    [cell.MakeMoney setTitle:_showbtnText forState:UIControlStateNormal];
                    [cell.MakeMoney setBackgroundImage:[UIImage imageNamed:@"licaichaoshi-btn-hui"] forState:UIControlStateNormal];
                }else{
                    [cell.MakeMoney setTitle:_showbtnText forState:UIControlStateNormal];
                    [cell.MakeMoney addTarget:self action:@selector(MakeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
                    cell.MakeMoney.tag=401;
                }
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)MakeMoneyClick:(UIButton *)btn{
    
    if (btn.tag==400) {
        NSLog(@"精选赚钱");
        UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
        NSIndexPath * path = [_fineSelectTableView indexPathForCell:cell];
        NSLog(@"index row%ld", (long)[path row]);
        if (_fineSelectArray.count!=0) {
            _productModel=_fineSelectArray[path.row];
            RegularProductDetailsViewController *regularViewController=[[RegularProductDetailsViewController alloc]initWithNibName:@"RegularProductDetailsViewController" bundle:nil];
            regularViewController.productModel=_productModel;
            [self.navigationController pushViewController:regularViewController animated:YES];
        }
        //_productModel=_fineSelectArray[path.row];
        
    }else if (btn.tag==401){
        NSLog(@"活期赚钱");
        UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
        NSIndexPath * path = [_fineSelectTableView indexPathForCell:cell];
        NSLog(@"index row%ld", (long)[path row]);
        if (_fineSelectArray.count!=0) {
            _productModel=_fineSelectArray[path.row];
            RegularProductDetailsViewController *regularViewController=[[RegularProductDetailsViewController alloc]initWithNibName:@"RegularProductDetailsViewController" bundle:nil];
            regularViewController.productModel=_productModel;
            [self.navigationController pushViewController:regularViewController animated:YES];
        }
        
    }else if (btn.tag==402){
        // 纯定期
        UITableViewCell * cell = (UITableViewCell *)[[btn superview] superview];
        NSIndexPath * path = [_regularTableView indexPathForCell:cell];
        NSLog(@"index row%ld", (long)[path row]);
        if (_regularArray.count!=0) {
            _productModel=_regularArray[path.row];
            RegularProductDetailsViewController *regularViewController=[[RegularProductDetailsViewController alloc]initWithNibName:@"RegularProductDetailsViewController" bundle:nil];
            regularViewController.productModel=_productModel;
            [self.navigationController pushViewController:regularViewController animated:YES];
        }
        
    }
}

-(void)LeftandRightClick:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 请求产品列表
-(void)requestProductList{
    [[BtmMobile shareBtmMoile]startMove:self];
    NSMutableDictionary *paramDict=[[SYMPublicDictionary shareDictionary]ProductListPublicDictnary:@"" productCode:@"" distributorCode:@"" positionId:@"4f08f333d833f292"];
    [SYMAFNHttp post:SYMProductList_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObjProductList-->%@",responsedict);
        
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *array=responsedict[@"data"];
            for (NSDictionary *dictList in array) {
                ProductList *productModel=[[ProductList alloc]init];
                productModel.unit=dictList[@"unit"];
                productModel.minInvest=dictList[@"minInvest"];
                productModel.standardProfit=dictList[@"standardProfit"];
                productModel.rate=dictList[@"rate"];
                productModel.period=dictList[@"period"];
                productModel.productCode=dictList[@"productCode"];
                productModel.expandProfit=dictList[@"expandProfit"];
                productModel.productCatCode=dictList[@"productCatCode"];
                productModel.productType=dictList[@"productType"];
                productModel.remaining=dictList[@"remaining"];
                productModel.productName=dictList[@"productName"];
                productModel.TagName=dictList[@"tagName"];
                productModel.sellStatus=dictList[@"sellStatus"];
                productModel.terminalProfit=dictList[@"terminalProfit"];
                productModel.purchaserProfit=dictList[@"purchaserProfit"];
                productModel.purchaserType=dictList[@"purchaserType"];
                productModel.isdistribute=dictList[@"isDistribute"];
                [_fineSelectArray addObject:productModel];
            }
            
            // 请求接口
            [self requestRegularProductList];
        }else{
            [self requestRegularProductList];
            return ;
        }
        
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        [self requestRegularProductList];
    }];
}

#pragma mark- 请求定期产品列表
-(void)requestRegularProductList{
    
    NSMutableDictionary *paramDict=[[SYMPublicDictionary shareDictionary]ProductListPublicDictnary:@"" productCode:@"" distributorCode:@"" positionId:@"b9bbbc8eebfc4669"];
    [SYMAFNHttp post:SYMProductList_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"RegularProductList-->%@",responsedict);
        // 请求
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *array=responsedict[@"data"];
            for (NSDictionary *dictList in array) {
                // model赋值
                ProductList *productModel=[[ProductList alloc]init];
                productModel.unit=dictList[@"unit"];
                productModel.minInvest=dictList[@"minInvest"];
                productModel.standardProfit=dictList[@"standardProfit"];
                productModel.rate=dictList[@"rate"];
                productModel.period=dictList[@"period"];
                productModel.productCode=dictList[@"productCode"];
                productModel.expandProfit=dictList[@"expandProfit"];
                productModel.productCatCode=dictList[@"productCatCode"];
                productModel.productType=dictList[@"productType"];
                productModel.remaining=dictList[@"remaining"];
                productModel.productName=dictList[@"productName"];
                productModel.TagName=dictList[@"tagName"];
                productModel.sellStatus=dictList[@"sellStatus"];
                productModel.terminalProfit=dictList[@"terminalProfit"];
                productModel.purchaserProfit=dictList[@"purchaserProfit"];
                productModel.purchaserType=dictList[@"purchaserType"];
                productModel.isdistribute=dictList[@"isDistribute"];
                [_regularArray addObject:productModel];
            }
            [_regularTableView reloadData];
            [_fineSelectTableView reloadData];
            [[BtmMobile shareBtmMoile]stopMove];
            
        }else{
            [_regularTableView reloadData];
            [_fineSelectTableView reloadData];
            [[BtmMobile shareBtmMoile]stopMove];
            return ;
        }
        
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        [[BtmMobile shareBtmMoile]stopMove];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        
    }];
}

#pragma mark- 匹配日期
-(NSString *)matchLimtTime:(NSString *)unit{
    
    NSString *limitTim=@"无";
    if ([unit isEqualToString:@"Y"]) {
        limitTim=@"年";
    }else if ([unit isEqualToString:@"M"]){
        limitTim=@"月";
        
    }else if ([unit isEqualToString:@"D"]){
        limitTim=@"日";
    }
    return limitTim;
}

#pragma mark- 显示状态
-(BOOL)statusbtnType:(NSString *)status isstatus:(BOOL)isstatus{
    BOOL result=NO;
    switch ([status intValue]) {
        case 0:
        {
            _showbtnText=@"预售";
            result=NO;
        }
            break;
        case 1:
        {
            if (isstatus) {
                _showbtnText=@"立即抢购";
            }else{
                _showbtnText=@"马上赚钱";
            }
            
            result=NO;
        }
            break;
        case 2:
        {
            _showbtnText=@"售罄";
            result=YES;
        }
            break;
        case 3:
        {
            _showbtnText=@"流标";
            result=NO;
        }
            break;
        case 4:
        {
            _showbtnText=@"还款中";
            result=NO;
        }
            break;
        case 5:
        {
            _showbtnText=@"还款完成";
            result=NO;
        }
            break;
            
        default:
            break;
    }
    return result;
}

#pragma mark- 判断有无网络环境
-(BOOL)ishaveNetwork
{
    if ([[ZplayNoject shareInstance]isHaveConnect]) {
        return YES;
    }else{
        // 没有网
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
        return NO;
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

//
//  SYMAssetReflectViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMNewAssetReflectViewController.h"
#import "SYMConstantCenter.h"
#import "SYMPickerView.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"
#import "SYMAssetTakeOutResultsViewController.h"
#import "SYMNewAssetReflectTableViewCell.h"
#import "SYMTabController.h"
#import "MyTipsWindow.h"


@interface SYMNewAssetReflectViewController ()<SYMPickerView,UITextFieldDelegate>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    SYMPickerView *bpv;
    SYMPickerView *bpv2;
    NSMutableArray *_participateArray;
    NSMutableArray *_partCityArray;
    double movedistance;
    NSString *_cashMoney;
    NSMutableArray *_listchashArray;
    NSMutableArray *_WithdrawalArray;
    NSMutableArray *_CityArray;
    NSMutableArray *_ProvinceArray;
    NSMutableArray *arr;
    NSMutableArray *_drawalresultArray;
    BOOL isresult;
    NSInteger _indexRow;
    NSInteger _selectIndexrows;
    NSString *ProvinceValues;
    NSString *CityValues;
    NSString *ReflectMoney;
    NSString *_saveProvinceCdoe;
    NSMutableArray *_arrayRows;
    UITextField *_branchTextFiled;
    NSMutableArray *_savebranchName;
    BOOL Isbranchswitch;
}
@end

@implementation SYMNewAssetReflectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationView];
    self.tableview.tableFooterView=[[UIView alloc]init];
    self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    _indexRow=-1;
    _selectIndexrows=-1;
    //Isbranchswitch=YES;
    _participateArray = [[NSMutableArray alloc]init];
    _partCityArray=[[NSMutableArray alloc]init];
    _listchashArray=[[NSMutableArray alloc]init];
    _WithdrawalArray=[[NSMutableArray alloc]init];
    _CityArray=[[NSMutableArray alloc]init];
    _ProvinceArray=[[NSMutableArray alloc]init];
    arr=[[NSMutableArray alloc]init];
    _drawalresultArray=[[NSMutableArray alloc]init];
    _arrayRows=[[NSMutableArray alloc]init];
    _savebranchName=[[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *_myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack:)];
    [self.view addGestureRecognizer:_myTap];
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"提现";
    
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

#pragma mark- 提现按钮
-(IBAction)ClickBtn:(id)sender{
    
    UIButton *button=(UIButton *)sender;
    if (button.tag==202)
    {
        BOOL isCanRequest=NO;
        for (NSString *row in _arrayRows) {   // _arrayRows 存得是选中cell的行号
            ListCash *model= _listchashArray[[row intValue]]; // 记录的行号和数据模型第几个一样
            if (_savebranchName.count!=0) {
                for (NSDictionary *dict in _savebranchName) {
                    if ([[dict allKeys] containsObject:row]) {
                        NSMutableDictionary *mutableDict=dict[row];
                        if (![[SYMPublicDictionary shareDictionary]judgeString:mutableDict[@"Province"]]&&![[SYMPublicDictionary shareDictionary]judgeString:mutableDict[@"City"]]&&![[SYMPublicDictionary shareDictionary]judgeString:mutableDict[@"branch"]]) {
                            NSLog(@"mutableDict=%@",mutableDict);
                            // model.cashAvailable
                            NSMutableDictionary *paramDictarrlist=[[NSMutableDictionary alloc]initWithCapacity:10];
                            paramDictarrlist=[[SYMPublicDictionary shareDictionary]RegularWithdrawalparameterPublicDictnary:model.distributorCode userId:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] amount:mutableDict[@"withdrawalmoney"] province:mutableDict[@"Province"] city:[NSString stringWithFormat:@"%@",mutableDict[@"City"]] locusName:mutableDict[@"branch"]];
                            [arr addObject:paramDictarrlist];
                            isCanRequest=YES;
                        }else{
                            NSLog(@"请填写支行或城市");
                            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请填写支行或城市" backgroundcolor:white];
                        }
                    }
                }
            }else{
                NSLog(@"请填写支行名称");
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请填写支行名称" backgroundcolor:white];
            }
        }
        if (isCanRequest) {
            //调用提现
            [self requestwithdrawal];
        }
    }
}

#pragma mark- 选择省份/城市
-(void)functionClick:(UIButton *)button{
    
    if (button.tag==200) {
        // 请求省接口
        if (_ProvinceArray.count!=0) {
            [_ProvinceArray removeAllObjects];
        }
        if (_participateArray.count!=0) {
            [_participateArray removeAllObjects];
        }
        UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
        NSIndexPath * path = [self.tableview indexPathForCell:cell];
        _selectIndexrows=path.row; // 选择的cell 行数
        if (_listchashArray.count!=0) {
            ListCash *model=_listchashArray[path.row];
            [self requestprovinces:model.distributorCode];
        }
        
    }else if (button.tag==201){
        // 市
        if ([[SYMPublicDictionary shareDictionary]judgeString:ProvinceValues]) {
            NSLog(@"请选择省");
            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"请选择省" backgroundcolor:white];
            return;
        }
        if (_partCityArray.count!=0) {
            [_partCityArray removeAllObjects];
        }
        if (_CityArray.count!=0) {
            [_CityArray removeAllObjects];
        }
        
        UITableViewCell * cell = (UITableViewCell *)[[button superview] superview];
        NSIndexPath * path = [self.tableview indexPathForCell:cell];
        _selectIndexrows=path.row; // 选择的cell 行数
        if (_listchashArray.count!=0) {
            ListCash *model=_listchashArray[path.row];
            // 省得code
            NSLog(@"provinceCount=%lu",(unsigned long)_ProvinceArray.count);
            if (_ProvinceArray.count!=0) {
                for (Province *provi in _ProvinceArray) {
                    
                    if ([[NSString stringWithFormat:@"%@",provi.name] isEqualToString:ProvinceValues]) {
                        NSLog(@"provi.name=%@,ProvinceValues=%@",provi.name,ProvinceValues);
                        // 请求市的接口
                        [self requestCity:provi.code distributorCode:model.distributorCode];
                    }
                }
            }
        }
    }
}


#pragma mark- PickViewDelegate
-(void)finallyNumber:(NSString *)number pickerView:(SYMPickerView *)pickerView{
    
    if (pickerView==bpv) {
        ProvinceValues=number;
    }else if (pickerView==bpv2){
        CityValues=number;
    }
    [self.tableview reloadData];
}

//-(void)pickerViewSelcetRow:(NSInteger)row SelectTitle:(NSString *)title pickerView:(SYMPickerView *)pickerView{
//
//
//
//}

#pragma mark- Textfiled
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
#if 0
    UITableViewCell * cell = (UITableViewCell *)[[_branchTextFiled superview] superview];
    NSIndexPath * path = [self.tableview indexPathForCell:cell];
    NSLog(@"path.row=%ld",_branchTextFiled.tag);
    
    if (_branchTextFiled.tag==path.row) {
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        //self.BDScrollerView.contentOffset=CGPointMake(0, 50);
        if (self.tableview.frame.size.height-(_branchTextFiled.frame.origin.y+_branchTextFiled.frame.size.height)<height) {
            
            CGFloat Lowhight=height-(self.tableview.frame.size.height-(_branchTextFiled.frame.origin.y+_branchTextFiled.frame.size.height));
            NSLog(@"屏幕高度--->%f",Lowhight);
            [UIView animateWithDuration:0.3f animations:^{
                self.tableview.transform=CGAffineTransformMakeTranslation(0,-Lowhight-65);
            }];
        }
    }
    //   NSLog(@"cell.baranchName=%@",cell.BranchName.text);
    //_branchTextFiled
#endif
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //    SYMNewAssetReflectTableViewCell * cell = (SYMNewAssetReflectTableViewCell *)[[_branchTextFiled superview] superview];
    //    NSLog(@"cell.baranchName=%@",cell.BranchName.text);
}
-(void)tapBack:(UITapGestureRecognizer *) tap{
    [_branchTextFiled resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        self.tableview.transform=CGAffineTransformMakeTranslation(0,0);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self registerForKeyboardNotifications];
    if (_listchashArray.count!=0) {
        [_listchashArray removeAllObjects];
    }
    SYMTabController *tabcontrol=(SYMTabController *)self.tabBarController;
    [tabcontrol hidenTabBar:YES];
    [self RegularWithdrawalSearch];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    istrue=YES;
    [super viewWillDisappear:animated];
}

#pragma mark- 定期提现查询
-(void)RegularWithdrawalSearch
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]MyAssetsPublicDictnary:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMRegularWithdrawalQuery_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSDictionary *dict=responsedict[@"data"];
            self.CanreflectLabel.text=[NSString stringWithFormat:@"%@",dict[@"cashMoney"]];
            _cashMoney=dict[@"cashMoney"];
            NSArray *array=dict[@"listCash"];
            for (NSDictionary *dictLsit in array) {
                ListCash *listchashModel=[[ListCash alloc]init];
                listchashModel.bankCode=dictLsit[@"bankCode"];
                listchashModel.bankName=dictLsit[@"bankName"];
                listchashModel.cardNo=dictLsit[@"cardNo"];
                listchashModel.cashAvailable=dictLsit[@"cashAvailable"];
                listchashModel.distributorCode=dictLsit[@"distributorCode"];
                listchashModel.distributorName=dictLsit[@"distributorName"];
                listchashModel.withdrawalType=dictLsit[@"withdrawalType"];
                if ([[NSString stringWithFormat:@"%@",dictLsit[@"cashAvailable"]] intValue]>0) {
                    [_listchashArray addObject:listchashModel];
                }
            }
            // 更新tableview
            [self.tableview reloadData];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 提现
-(void)requestwithdrawal
{
    
    NSLog(@"arr=>>%@",arr);
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    NSError* error = nil;
    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:arr
                                                      options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonstr =[[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    paramDict=[[SYMPublicDictionary shareDictionary]RegularWithdrawalPublicDictnary:jsonstr];
    NSLog(@"WithdrawalparamDict--->%@",paramDict);
    
    [SYMAFNHttp post:SYMRegularWithdrawal_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        //BOOL Continue=NO;
        NSLog(@"drawalresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *arrList=responsedict[@"data"];
            for (NSDictionary *dict in arrList) {
                if ([dict[@"code"] isEqualToString:@"1000"]) {
                    WithdrawalResults *model=[[WithdrawalResults alloc]init];
                    model.cashMoney=dict[@"cashMoney"];
                    model.bankName=dict[@"bankName"];
                    model.cardNo=dict[@"cardNo"];
                    model.companyName=dict[@"companyName"];
                    model.toDate=dict[@"toDate"];
                    [_drawalresultArray addObject:model];
                    //Continue=YES;
                }else{
                    NSLog(@"codeerror=%@",dict[@"message"]);
                }
            }
            if (_drawalresultArray.count!=0) {
                [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"提现成功" backgroundcolor:white];
                SYMAssetTakeOutResultsViewController *outResult=[[SYMAssetTakeOutResultsViewController alloc]init];
                outResult.drawalresultArray=_drawalresultArray;
                [self.navigationController pushViewController:outResult animated:YES];
            }
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark-更新UI
-(void)updateControls:(NSMutableArray *)arrayModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        ListCash *model=_listchashArray[0];
        //        self.NameNumber.text=[NSString stringWithFormat:@"%@",model.distributorName];
        //        self.ReflectMoneyLabel.text=[NSString stringWithFormat:@"%@",model.cashAvailable];
        //        self.BankcardLabel.text=[NSString stringWithFormat:@"%@",model.bankName];
        
        
        //        [self requestprovinces:model.distributorCode];
        //        [self requestCity:@"110000" distributorCode:model.distributorCode];
        
    });
    
}

#pragma mark- 省份接口
// 可以一起查出来
-(void)requestprovinces:(NSString *)distributorCode
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]ProvincePublicDictnary:distributorCode];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMProvinceList_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"provincesresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *array=responsedict[@"data"];
            for (NSDictionary *dict in array) {
                Province *provi=[[Province alloc]init];
                provi.code=dict[@"code"];
                provi.name=dict[@"name"];
                NSLog(@"provi.name=%@",provi.name);
                NSLog(@"provi.code=%@",provi.code);
                [_ProvinceArray addObject:provi];
                [_participateArray addObject:provi.name];
            }
            NSLog(@"选择省");
            bpv = [[SYMPickerView alloc]initWithArray:_participateArray];
            bpv.delegate = self;
            [self.tabBarController.view addSubview:bpv];
            // [self.tableview reloadData];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
    
}

#pragma mark- 城市接口
-(void)requestCity:(NSString *)citycode distributorCode:(NSString *)distributorCode
{
    _saveProvinceCdoe=citycode;
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]CityPublicDictnary:distributorCode provinceCode:citycode];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMCityList_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *array=responsedict[@"data"];
            for (NSDictionary *dict in array) {
                City *city=[[City alloc]init];
                city.cityCode=dict[@"code"];
                city.cityName=dict[@"name"];
                NSLog(@"city.cityName=%@",city.cityName);
                NSLog(@"city.cityCode=%@",city.cityCode);
                [_partCityArray addObject:city.cityName];
                [_CityArray addObject:city];
            }
            
            NSLog(@"选择市");
            bpv2 = [[SYMPickerView alloc]initWithArray:_partCityArray];
            bpv2.delegate = self;
            [self.tabBarController.view addSubview:bpv2];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}


-(NSData*)JSONString;
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

#pragma mark TableViewDelegate || TableViewDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listchashArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identity=@"cell";
    SYMNewAssetReflectTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Identity];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYMNewAssetReflectTableViewCell" owner:self options:nil] lastObject];
    }
    if (_listchashArray.count!=0) {
        ListCash *model=_listchashArray[indexPath.row];
        cell.NameLabel.text=[NSString stringWithFormat:@"%@",model.distributorName];
        cell.ReflectMoneyLabel.text=[NSString stringWithFormat:@"%@",model.cashAvailable];
        ReflectMoney=[NSString stringWithFormat:@"%@",model.cashAvailable];
        cell.BankcardLabel.text=[NSString stringWithFormat:@"%@",model.bankName];
    }
    if (_selectIndexrows==indexPath.row) {
        if ([[SYMPublicDictionary shareDictionary]judgeString:CityValues]) {
            cell.CityLabel.text=@"请选择市";
            cell.CityLabel.textColor=[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1];
        }else{
            cell.CityLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            cell.CityLabel.text=CityValues;
        }
        
        if ([[SYMPublicDictionary shareDictionary]judgeString:ProvinceValues]) {
            cell.ProvinceLabel.textColor=[UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1];
            cell.ProvinceLabel.text=@"请选择省";
        }else{
            cell.ProvinceLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            cell.ProvinceLabel.text=ProvinceValues;
        }
        
    }
    
    // 多选cell
    if (_indexRow==-1) {
        [cell createCellViewsWithItemInfo:NO]; // no:小图，yes:大图
    }else{
        
        BOOL isHaveRow=NO;
        if (_arrayRows.count!=0) {
            for (NSString *row in _arrayRows) {
                if (indexPath.row==[row intValue]) {
                    isHaveRow=YES;
                }
            }
            if (isHaveRow) {
                isHaveRow=NO;
                [cell createCellViewsWithItemInfo:YES]; // no:小图，yes:大图
            }else{
                [cell createCellViewsWithItemInfo:NO]; // no:小图，yes:大图
            }
            
        }else{
            [cell createCellViewsWithItemInfo:NO]; // no:小图，yes:大图
        }
    }
    
    cell.clickbutton.tag=indexPath.row;
    [cell.clickbutton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    cell.ProvinceButton.tag=200;
    [cell.ProvinceButton addTarget:self action:@selector(functionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.CityButton.tag=201;
    [cell.CityButton addTarget:self action:@selector(functionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.BranchName.tag=indexPath.row;
    cell.BranchName.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_indexRow==-1) {
        return 150;
    }else{
        int pathrow=150;
        BOOL ishaveRows=NO;
        if (_arrayRows.count!=0) {
            for (NSString *row in _arrayRows) {
                if (indexPath.row==[row intValue]) { // 数组的值和每个cell行号比较
                    ishaveRows=YES;
                }
            }
            if (ishaveRows) {
                return pathrow=321;
            }else{
                return pathrow=150;
            }
        }
        return pathrow;
    }
    
}

#pragma mark- 选择提现的个数
static bool istrue=YES;
-(void)click:(UIButton *)btn
{
    // if (Isbranchswitch) { // 默认填写了支行名称
    //     Isbranchswitch=NO;
    // 选中
    if (istrue) {
        // 存入选中的cell
        [_arrayRows addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        istrue=NO;
        _indexRow=btn.tag;
        [self.tableview reloadData];
    }else{
        BOOL isselect=NO;
        NSMutableArray *newarray=[_arrayRows copy];
        for (NSString *row in newarray) {
            NSLog(@"btn.tag=%ld",(long)btn.tag);
            if ([row intValue]==btn.tag) {
                [_arrayRows removeObject:row];
                // 不选中
                istrue=NO;   // 用于区分第几次点击按钮
                isselect=YES;
            }
        }
        
        if (!isselect) {
            // 2次不是选中的同一个cell
            // 存入选中的cell
            [_arrayRows addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            istrue=NO;
        }
        [self.tableview reloadData];
    }
    
    // }else{
    //     NSLog(@"请填写择支行");
    // }
    
}


#pragma mark- TextFiledDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //self.tableview.transform=CGAffineTransformMakeTranslation(0,0);
    NSLog(@"textField->%@",textField.text);
    NSLog(@"textField.tag=%ld",(long)textField.tag);
    //_branchTextFiled=textField;
    NSMutableDictionary *mutabledict=[[NSMutableDictionary alloc]init];
    //UITableViewCell * cellid = (UITableViewCell *)[[textField superview] superview];
    //NSIndexPath * path = [self.tableview indexPathForCell:cellid];
    //SYMNewAssetReflectTableViewCell *cell=(SYMNewAssetReflectTableViewCell*)[self.tableview cellForRowAtIndexPath:path];
    
    [mutabledict setObject:[NSString stringWithFormat:@"%@",ProvinceValues] forKey:@"Province"];
    [mutabledict setObject:[NSString stringWithFormat:@"%@",CityValues] forKey:@"City"];
    [mutabledict setObject:[NSString stringWithFormat:@"%@",textField.text] forKey:@"branch"];
    [mutabledict setObject:[NSString stringWithFormat:@"%@",ReflectMoney] forKey:@"withdrawalmoney"];
    
    //    [mutabledict setObject:@"Province" forKey:[NSString stringWithFormat:@"%@",cell.ProvinceLabel.text]];
    //    [mutabledict setObject:@"City" forKey:[NSString stringWithFormat:@"%@",cell.CityLabel.text]];
    //    [mutabledict setObject:@"branch" forKey:[NSString stringWithFormat:@"%@",textField.text]];
    
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setValue:mutabledict forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
    [_savebranchName addObject:dict];
    
    
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _branchTextFiled=textField;
    self.tableview.transform=CGAffineTransformMakeTranslation(0,-90);
    NSLog(@"textField->%@",textField.text);
    //Isbranchswitch=YES;
    return YES;
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

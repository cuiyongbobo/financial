//
//  SYMAssetReflectViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMAssetReflectViewController.h"
#import "SYMConstantCenter.h"
#import "SYMPickerView.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMDataBaseModel.h"
#import "SYMAssetTakeOutResultsViewController.h"


@interface SYMAssetReflectViewController ()<SYMPickerView>
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
    SYMPickerView *bpv;
    SYMPickerView *bpv2;
    NSMutableArray *_participateArray;
    double movedistance;
    NSString *_cashMoney;
    NSMutableArray *_listchashArray;
    NSMutableArray *_WithdrawalArray;
    NSMutableArray *_CityArray;
    NSMutableArray *_ProvinceArray;
    NSMutableArray *arr;
    NSMutableArray *_drawalresultArray;
}
@end

@implementation SYMAssetReflectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationView];
    [self.ProvinceButton pointInside:CGPointMake(300, 300) withEvent:nil];
    [self.CityButton pointInside:CGPointMake(300, 300) withEvent:nil];
    _participateArray = [[NSMutableArray alloc]initWithArray:@[@"北京",@"上海",@"广州"]];
    _listchashArray=[[NSMutableArray alloc]init];
    _WithdrawalArray=[[NSMutableArray alloc]init];
    _CityArray=[[NSMutableArray alloc]init];
    _ProvinceArray=[[NSMutableArray alloc]init];
    arr=[[NSMutableArray alloc]init];
    _drawalresultArray=[[NSMutableArray alloc]init];
    NSLog(@"participate %@",_participateArray);
    
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
    companyAccount.text=@"体现";
    
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

-(IBAction)ClickBtn:(id)sender{
    SYMCustomButton *button=(SYMCustomButton *)sender;
    
    if (button.tag==200) {
        
        NSLog(@"选择省");
        bpv = [[SYMPickerView alloc]initWithArray:_participateArray];
        //bpv = [[SYMPickerView alloc]initWithArray:_participateArray]; _ProvinceArray
        bpv.delegate = self;
        [self.tabBarController.view addSubview:bpv];
        
    }else if (button.tag==201){
        NSLog(@"选择市");
        bpv2 = [[SYMPickerView alloc]initWithArray:_participateArray];
        bpv2.delegate = self;
        [self.tabBarController.view addSubview:bpv2];
    }else if (button.tag==202)
    {
        ListCash *model=_listchashArray[0];
        NSMutableDictionary *paramDictarrlist=[[NSMutableDictionary alloc]initWithCapacity:10];
        paramDictarrlist=[[SYMPublicDictionary shareDictionary]RegularWithdrawalparameterPublicDictnary:model.distributorCode userId:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN] amount:@"100000" province:@"110000" city:@"110000" locusName:model.distributorName];
        
        [arr addObject:paramDictarrlist];
        // 提现
        [self requestwithdrawal];
    }
}


#pragma mark- PickView

-(void)finallyNumber:(NSString *)number pickerView:(SYMPickerView *)pickerView{
    
    if (pickerView==bpv) {
        //
        self.ProvinceLabel.text=number;
        
    }else if (pickerView==bpv2){
        //
        self.CityLabel.text=number;
    }
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
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    // self.BDScrollerView.contentOffset=CGPointMake(0, 50);
    if (self.BDScrollerView.frame.size.height-(self.BranchName.frame.origin.y+self.BranchName.frame.size.height)<height) {
        
        CGFloat Lowhight=height-(self.BDScrollerView.frame.size.height-(self.BranchName.frame.origin.y+self.BranchName.frame.size.height));
        NSLog(@"屏幕高度--->%f",Lowhight);
        [UIView animateWithDuration:0.3f animations:^{
            self.BDScrollerView.contentOffset=CGPointMake(0, Lowhight);
        }];
    }
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //    dispatch_queue_t queue=dispatch_get_main_queue();
    //    dispatch_async(queue, ^{
    //
    //        if (_EmailTextField.text.length==0 || _PassWordTextField.text.length==0) {
    //
    //            [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:NSLocalizedString(@"UserErrorNULL", nil) backgroundcolor:black];  // 背景为白色的提示框的颜色为黑色的
    //        }
    //
    //    });
    //
    //    [UIView  animateWithDuration:0.3f animations:^{
    //
    //       // self.BTMScrollview.contentOffset = CGPointMake(0,0);
    //       // self.view.transform=CGAffineTransformMakeTranslation(0, -Lowhight+13);
    //
    //    }];
    
}
-(void)tapBack:(UITapGestureRecognizer *) tap{
    //[self.BranchName restrict];
    [self.BranchName resignFirstResponder];
    self.BDScrollerView.contentOffset=CGPointMake(0, 0);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self RegularWithdrawalSearch];
}
-(void)viewWillDisappear:(BOOL)animated
{
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
                [_listchashArray addObject:listchashModel];
            }
            [self updateControls];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark- 提现
-(void)requestwithdrawal
{
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
        NSLog(@"loginresponseObj-->%@",responsedict);
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            NSArray *arrList=responsedict[@"data"];
            for (NSDictionary *dict in arrList) {
                WithdrawalResults *model=[[WithdrawalResults alloc]init];
                model.cashMoney=dict[@"cashMoney"];
                model.bankName=dict[@"bankName"];
                model.cardNo=dict[@"cardNo"];
                model.companyName=dict[@"companyName"];
                model.toDate=dict[@"toDate"];
                [_drawalresultArray addObject:model];
            }
            SYMAssetTakeOutResultsViewController *outResult=[[SYMAssetTakeOutResultsViewController alloc]init];
            outResult.drawalresultArray=_drawalresultArray;
            [self.navigationController pushViewController:outResult animated:YES];
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
}

#pragma mark-更新UI
-(void)updateControls
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ListCash *model=_listchashArray[0];
        self.NameNumber.text=[NSString stringWithFormat:@"%@",model.distributorName];
        self.ReflectMoneyLabel.text=[NSString stringWithFormat:@"%@",model.cashAvailable];
        self.BankcardLabel.text=[NSString stringWithFormat:@"%@",model.bankName];
        [self requestprovinces:model.distributorCode];
        [self requestCity:@"110000" distributorCode:model.distributorCode];
    });
}

#pragma mark- 省份接口
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
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
    }];
    
}

#pragma mark- 城市接口
-(void)requestCity:(NSString *)citycode distributorCode:(NSString *)distributorCode
{
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
                [_CityArray addObject:city];
            }
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
    
   // NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 //encoding:NSUTF8StringEncoding];
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

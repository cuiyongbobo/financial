//
//  SYMHomeViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#import "SYMHomeViewController.h"
#import "SYMConstantCenter.h"
#import "SYMAFNHttp.h"
#import "SYMPublicDictionary.h"
#import "VWWWaterView.h"
#import "SYMDataBaseModel.h"
#import "UIImageView+WebCache.h"
#import "RegularProductDetailsViewController.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "SYMdistributionViewController.h"
#import "GestureViewController.h"
#import "SYMNewsecurityViewController.h"
#import "SYMconsultingViewController.h"
#import "MyTipsWindow.h"
#import "SYMDataBaseCenter.h"
#import "BtmMobile.h"
#import "PCCircleViewConst.h"
#import "Reachability.h"
#import "ZplayNoject.h"

@interface SYMHomeViewController ()<UIScrollViewDelegate>
{
    UIImageView *_TitleImage;
    UILabel     *companyAccount;
    NSTimer *_selftimers;
    NSMutableArray *_bannerArray;
    NSMutableArray *_ProductListArray;
    dispatch_queue_t _serialQueue;
    NSString *productCode;
    NSString *_showbtnText;
    //NSMutableArray *slideImages;
}
@end

#define advertisementViewTag 2000
@implementation SYMHomeViewController

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.BDScrollView.header.updatedTimeHidden=YES;
    });
    
    NSArray *array=[[SYMDataBaseCenter defaultDatabase]getAllinformationByUserid:[[NSUserDefaults standardUserDefaults] objectForKey:ISLogIN]];
    if (array.count!=0) {
        for (UserInformation *userinformation in array) {
            // 给手势密码赋值
            [[NSUserDefaults standardUserDefaults]setObject:userinformation.gesturespassword forKey:gestureFinalSaveKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            [gestureVc setType:GestureViewControllerTypeLogin];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:LoginPage];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController pushViewController:gestureVc animated:NO];
        }
    }
    
    self.automaticallyAdjustsScrollViewInsets = false;
    _bannerArray=[[NSMutableArray alloc]init];
    _ProductListArray=[[NSMutableArray alloc]init];
    self.BannerHightConstra.constant=SYMHEIGHTRATESCALE*168;
    self.DisplayListHeight.constant=SYMHEIGHTRATESCALE*56;
    
    [self initNavigationView];
    
    // 谁波纹动画
    VWWWaterView *waterView = [[VWWWaterView alloc]initWithFrame:self.CheckDetailsImageView.bounds];
    [self.CheckDetailsImageView addSubview:waterView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // MJ刷新
    //[self.BDScrollView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(doFooterRefresh)];
    [self.BDScrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(doHeaderRefresh)];
    
    // CheckDetailsImageView
    UITapGestureRecognizer *_myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChange:)];
    [self.CheckDetailsImageView addGestureRecognizer:_myTap];
}

-(void)tapChange:(UITapGestureRecognizer *) tap{
    
    if (_ProductListArray.count!=0) {
        ProductList *productModel=_ProductListArray[0];
        RegularProductDetailsViewController *producet=[[RegularProductDetailsViewController alloc]initWithNibName:@"RegularProductDetailsViewController" bundle:nil];
        producet.productModel=productModel;
        [self.navigationController pushViewController:producet animated:YES];
    }
}

-(void)doFooterRefresh
{
    //     currentPage ++;
    //    [self refreshNet];
}

-(void)doHeaderRefresh//刷新
{
    if (_bannerArray.count!=0) {
        [_bannerArray removeAllObjects];
    }
    
    if ([self ishaveNetwork]) {
        [self requestPersonalactivities];
    }
}

-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    // 定义Navigation的titleView
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"产品推荐";
    //公司账户
    companyAccount.textAlignment = NSTextAlignmentCenter;
    [companyAccount setTextColor:SYMFontColor];
    [_TitleImage addSubview:companyAccount];
}

-(void)imgPlay{
    [self turnPage];
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    //自动滚动事件
    int currentPage = floor(((self.scrollview.contentOffset.x - self.scrollview.frame.size.width/(_bannerArray.count+2)) / self.scrollview.frame.size.width)) + 2;
    self.pageControl.currentPage = currentPage - 1;
    [self.scrollview setContentOffset:CGPointMake(self.scrollview.frame.size.width * currentPage, 0)
                             animated:YES];
    if(currentPage == _bannerArray.count + 1)
        self.pageControl.currentPage = 0;
    if(currentPage == _bannerArray.count + 2){
        self.pageControl.currentPage = 1;
        [self.scrollview scrollRectToVisible:CGRectMake(self.scrollview.frame.size.width, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)
                                    animated:NO];
        [self.scrollview setContentOffset:CGPointMake(self.scrollview.frame.size.width*2, 0)
                                 animated:YES];
    }
}

-(void)initShuffling
{
    //CGFloat imageY=0;
    //CGFloat imageW=BTMWidth;
    //CGFloat imageH=self.BannerHightConstra.constant;
    self.scrollview.userInteractionEnabled=YES;
    self.scrollview.pagingEnabled=YES;
    self.scrollview.bounces=NO;
    self.scrollview.delegate=self;
    self.scrollview.showsHorizontalScrollIndicator=NO;
    self.scrollview.showsVerticalScrollIndicator=NO;
    self.pageControl.numberOfPages=_bannerArray.count;
    self.pageControl.currentPage=0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width*([_bannerArray count] + 2), self.scrollview.frame.size.height);
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
    FinancialSupermarket *supermarket=_bannerArray[[_bannerArray count]-1];
    NSString *picture=[NSString stringWithFormat:@"%@%@",SYMBannerAPI,supermarket.imgUrl];
    
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:picture]
                  placeholderImage:nil];
    [self.scrollview addSubview:imageView1];
    if([_bannerArray count] > 1){//如果广告个数大于1.就循环展示
        self.scrollview.scrollEnabled = YES;
        self.pageControl.hidden = NO;
        for (int i = 0; i <[_bannerArray count]; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollview.frame.size.width*(i + 1), 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
            if(i == 0){
                FinancialSupermarket *supermarket=_bannerArray[i];
                NSString *picture=[NSString stringWithFormat:@"%@%@",SYMBannerAPI,supermarket.imgUrl];
                NSLog(@"picture=%@",picture);
                [imageView sd_setImageWithURL:[NSURL URLWithString:picture]
                             placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }];
            }else{
                FinancialSupermarket *supermarket=_bannerArray[i];
                NSString *picture=[NSString stringWithFormat:@"%@%@",SYMBannerAPI,supermarket.imgUrl];
                [imageView sd_setImageWithURL:[NSURL URLWithString:picture]placeholderImage:nil];
            }
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *_myTapS = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackS:)];
            [imageView addGestureRecognizer:_myTapS];
            UIView *tagView=[_myTapS view];
            tagView.tag=2000+i;
            [self.scrollview addSubview:imageView];
        }
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollview.frame.size.width *([_bannerArray count] + 1), 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)];
        FinancialSupermarket *supermarkets=_bannerArray[0];
        NSString *pictures=[NSString stringWithFormat:@"%@%@",SYMBannerAPI,supermarkets.imgUrl];
        
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:pictures]
                      placeholderImage:nil];
        [self.scrollview addSubview:imageView2];
        self.scrollview.contentOffset = CGPointMake(self.scrollview.frame.size.width, 0);
        
        // 开始计时器播放图片
        if ([_selftimers isValid]) {
            [self timerOff];
        }
        [self timerOn];
        
    }else{
        //如果只有一张广告图，隐藏pagecontrol并增加该广告图
        [_selftimers invalidate];
        self.scrollview.scrollEnabled = NO;
        _pageControl.hidden = YES;
        imageView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *_myTapS = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackS:)];
        UIView *tagView=[_myTapS view];
        tagView.tag=2000+0;
        [imageView1 addGestureRecognizer:_myTapS];
    }
}

#pragma mark - scrollView代理方法
//当用户准备拖拽的时候，关闭定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView==self.scrollview) {
        [self timerOff];
    }else{
        
    }
}

//当用户停止拖拽的时候，添加一个定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView==self.scrollview) {
        [self timerOn];
    }
}

//每隔2秒调用imgPlay方法
-(void)timerOn{
    _selftimers=[NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(imgPlay) userInfo:nil repeats:YES];
    //为了防止单线程的弊端，可以保证用户在使用其他控件的时候系统照样可以让定时器运转
    [[NSRunLoop currentRunLoop]addTimer:_selftimers forMode:NSRunLoopCommonModes];
}

//关闭定时器，并且把定时器设置为nil，这是习惯
-(void)timerOff{
    [_selftimers invalidate];
    _selftimers=nil;
}

// 正在滚动时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView==self.scrollview) {
        //手动滚动事件
        int currentPage = floor((self.scrollview.contentOffset.x - self.scrollview.frame.size.width / (_bannerArray.count+2)) / self.scrollview.frame.size.width) + 1;
        self.pageControl.currentPage = currentPage - 1;
        if(currentPage == 0){
            self.pageControl.currentPage = _bannerArray.count - 1;
            [self.scrollview scrollRectToVisible:CGRectMake(self.scrollview.frame.size.width * _bannerArray.count, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)
                                        animated:NO];
        }else if(currentPage == _bannerArray.count + 1){
            self.pageControl.currentPage = 0;
            [self.scrollview scrollRectToVisible:CGRectMake(self.scrollview.frame.size.width, 0, self.scrollview.frame.size.width, self.scrollview.frame.size.height)
                                        animated:NO];
        }
    }
}

-(void)tapBackS:(UIGestureRecognizer *)tap
{
    UIView *singleTapViewS=[tap view];
    NSLog(@"view.tag=%ld",(long)singleTapViewS.tag);
    FinancialSupermarket *financialModel= _bannerArray[singleTapViewS.tag-2000];
    NSString *http=[financialModel.linkUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:http]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender{
    UIButton *button=(UIButton *)sender;
    NSLog(@"马上赚钱");
    if (button.tag==200) {
        SYMconsultingViewController *securityconsu=[[SYMconsultingViewController alloc]initWithNibName:@"SYMconsultingViewController" bundle:nil];
        [self.navigationController pushViewController:securityconsu animated:YES];
        
    }else if (button.tag==100){
        //正式的代码
        if (_ProductListArray.count!=0) {
            ProductList *productModel=_ProductListArray[0];
            RegularProductDetailsViewController *producet=[[RegularProductDetailsViewController alloc]initWithNibName:@"RegularProductDetailsViewController" bundle:nil];
            producet.productModel=productModel;
            [self.navigationController pushViewController:producet animated:YES];
        }
        
    }else if (button.tag==202)
    {
        [self determineUserIslogin];
    }else if (button.tag==201)
    {
        SYMNewsecurityViewController *security=[[SYMNewsecurityViewController alloc]initWithNibName:@"SYMNewsecurityViewController" bundle:nil];
        NSString *url=@"http://123.57.248.253/uap_server/safety";
        NSString *url_UTF8=[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        security.weburl=url_UTF8;
        [self.navigationController pushViewController:security animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:RegisteredSuccess];
    [_timer invalidate];
    _timer=nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isFirst=NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSuccess:) name:RegisteredSuccess object:nil];
    [self.navigationController.navigationBar setHidden:YES];
    
    if (_bannerArray.count!=0) {
        [_bannerArray removeAllObjects];
    }
    if ([self ishaveNetwork]) {
        [self requestPersonalactivities];
    }
}

#pragma mark- 通知方法
-(void)getSuccess:(NSNotification *)notify
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MyTipsWindow shareMytipview]HiddenTipView:NO viewcontroller:self tiptext:@"注册成功" backgroundcolor:white];
    });
}

#pragma mark -个人活动请求-获取banner
-(void)requestPersonalactivities{
    [[BtmMobile shareBtmMoile]startMove:self];
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    paramDict=[[SYMPublicDictionary shareDictionary]personalActivitiesPublicDictnary:@"444c34c1504f47c9"];
    NSLog(@"paramDict--->%@",paramDict);
    [SYMAFNHttp post:SYMPersonalActivities_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"responseObj-->%@",responsedict);
        NSDictionary *Maindict=responsedict;
        BOOL b=[[SYMPublicDictionary shareDictionary]judgeArray:Maindict[@"data"]];
        if (!b) {
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
            [self initShuffling];
            // 请求产品列表
            [self requestProductLsit];
        }else{
            [self requestProductLsit];
            return;
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        [self requestProductLsit];
    }];
}

#pragma mark -产品列表请求
static bool isFirst=NO;
-(void)requestProductLsit{
    NSMutableDictionary *paramDict=[[SYMPublicDictionary shareDictionary]ProductListPublicDictnary:@"" productCode:@"" distributorCode:@"" positionId:@"4422cf8c41184e7d"];
    [SYMAFNHttp post:SYMProductList_URL params:paramDict success:^(id responseObj){
        NSDictionary *responsedict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"responseObjProduct-->%@",responsedict);
        
        if ([[NSString stringWithFormat:@"%@",responsedict[@"code"]] isEqualToString:@"1000"]) {
            
            NSMutableArray *dataArray=responsedict[@"data"];
            for (NSDictionary *dict in dataArray) {
                // model赋值
                ProductList *productModel=[[ProductList alloc]init];
                productModel.unit=dict[@"unit"];
                productModel.minInvest=dict[@"minInvest"];
                productModel.standardProfit=dict[@"standardProfit"];
                productModel.rate=dict[@"rate"];
                productModel.period=dict[@"period"];
                productModel.productCode=dict[@"productCode"];
                productModel.expandProfit=dict[@"expandProfit"];
                productModel.productCatCode=dict[@"productCatCode"];
                productModel.productType=dict[@"productType"];
                productModel.remaining=dict[@"remaining"];
                productModel.productName=dict[@"productName"];
                productModel.TagName=dict[@"TagName"];
                productModel.sellStatus=dict[@"sellStatus"];
                productModel.terminalProfit=dict[@"terminalProfit"];
                productModel.purchaserProfit=dict[@"purchaserProfit"];
                productModel.purchaserType=dict[@"purchaserType"]; // isdistribute
                productModel.isdistribute=dict[@"isDistribute"];
                [_ProductListArray addObject:productModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_ProductListArray.count==0) {
                    if (!isFirst) {
                        isFirst=YES;
                        [[BtmMobile shareBtmMoile]stopMove];
                    }else{
                        [[BtmMobile shareBtmMoile]stopMove];
                        // 结束刷新
                        [self.BDScrollView.header endRefreshing];
                    }
                    
                    return;
                }
                ProductList *productModel=_ProductListArray[0];
                NSLog(@"productModel.rate=%@",productModel.rate);
                self.NumberPoundageLabel.text=productModel.rate;
                self.TimeLimitLabel.text=[NSString stringWithFormat:@"%@",productModel.period];
                self.CastLabel.text=[NSString stringWithFormat:@"%@",productModel.minInvest];
                self.LimitLabel.text=[NSString stringWithFormat:@"%@期限",[self matchLimtTime:productModel.unit]];
                self.StandardProfitLabel.text=[NSString stringWithFormat:@"%@",productModel.standardProfit];
                self.ShowTitleLabel.text=[NSString stringWithFormat:@"%@",productModel.productName];
                
                // 分销收益-已经加上扩展收益了
                double Calculatetotal=[[NSString stringWithFormat:@"%@",productModel.expandProfit] doubleValue];
                if ([[[NSUserDefaults standardUserDefaults]objectForKey:ISdistribution] isEqualToString:@"1"]) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",productModel.isdistribute] doubleValue];
                    
                }else{
                    // 新老用户
                    NSString *usertypeinfor=[[NSUserDefaults standardUserDefaults]objectForKey:UserType];
                    BOOL isc=[[SYMPublicDictionary shareDictionary]judgeString:usertypeinfor];
                    if (!isc) {
                        NSLog(@"productModel.purchaserType=%@",productModel.purchaserType);
                        if ([usertypeinfor isEqualToString:[NSString stringWithFormat:@"%@",productModel.purchaserType]]) {
                            Calculatetotal+=[[NSString stringWithFormat:@"%@",productModel.purchaserProfit] doubleValue];
                        }
                    }
                }
                
                NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
                // 终端收益
                BOOL c=[[SYMPublicDictionary shareDictionary]judgeString:userId];
                if (c) {
                    Calculatetotal+=[[NSString stringWithFormat:@"%@",productModel.terminalProfit] doubleValue];
                }
                
                self.AdditionalBenefitLabel.text=[NSString stringWithFormat:@"%.2f",Calculatetotal];
                if (Calculatetotal==0) {
                    // 隐藏
                    [self.BDAdditional setHidden:YES];
                    [self.AdditionalBenefitLabel setHidden:YES];
                    [self.AddLabel setHidden:YES];
                    self.Leftwidth.constant=13*SYMWIDthRATESCALE;
                    self.Centerwidth.constant=0;
                }
                //[self requestTerminalEarning:productModel.productCode expandProfit:productModel.expandProfit];
                
                BOOL b=[self statusbtnType:productModel.sellStatus isstatus:NO];
                if (b) {
                    self.MakeMoneybutton.enabled=NO;
                    self.MakeMoneybutton.selected=NO;
                    [self.MakeMoneybutton setTitle:_showbtnText forState:UIControlStateNormal];
                    [self.MakeMoneybutton setBackgroundImage:[UIImage imageNamed:@"btn_hui"] forState:UIControlStateNormal];
                }else{
                    [self.MakeMoneybutton setTitle:_showbtnText forState:UIControlStateNormal];
                }
                
                if (!isFirst) {
                    isFirst=YES;
                    [[BtmMobile shareBtmMoile]stopMove];
                }else{
                    [[BtmMobile shareBtmMoile]stopMove];
                    // 结束刷新
                    [self.BDScrollView.header endRefreshing];
                }
            });
            
        }else{
            // 请求失败
            
            if (!isFirst) {
                isFirst=YES;
                [[BtmMobile shareBtmMoile]stopMove];
            }else{
                [[BtmMobile shareBtmMoile]stopMove];
                // 结束刷新
                [self.BDScrollView.header endRefreshing];
            }
        }
    } failure:^(NSError *error){
        NSLog(@"error-->%@",error);
        if (!isFirst) {
            isFirst=YES;
            [[BtmMobile shareBtmMoile]stopMove];
        }else{
            [[BtmMobile shareBtmMoile]stopMove];
            // 结束刷新
            [self.BDScrollView.header endRefreshing];
        }
        
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

#pragma mark- 判断用户是否登录
-(void)determineUserIslogin
{
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:ISLogIN];
    BOOL b=[[SYMPublicDictionary shareDictionary]judgeString:userId];
    if (!b) { // 正常应该是!b
        // 登录成功
        // 分销
        SYMdistributionViewController *distribution=[[SYMdistributionViewController alloc]initWithNibName:@"SYMdistributionViewController" bundle:nil];
        distribution.weburl=[NSString stringWithFormat:@"http://123.57.248.253/webapp/share/toMyInvite?uname=%@&pwd=%@",[[NSUserDefaults standardUserDefaults] objectForKey:IPhonenumber],[[NSUserDefaults standardUserDefaults] objectForKey:UserPassword]];
        [self.navigationController pushViewController:distribution animated:YES];
    }else{
        // 去登陆
        dispatch_async(dispatch_get_main_queue(), ^{
            // 测试登录
            LoginViewController *login=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:login animated:YES];
            login.backLogin=^{
                // 登录成功
                // 分销
                SYMdistributionViewController *distribution=[[SYMdistributionViewController alloc]initWithNibName:@"SYMdistributionViewController" bundle:nil];
                // IPhonenumber
                distribution.weburl=[NSString stringWithFormat:@"http://123.57.248.253/webapp/share/toMyInvite?uname=%@&pwd=%@&terminal=2",[[NSUserDefaults standardUserDefaults] objectForKey:IPhonenumber],[[NSUserDefaults standardUserDefaults] objectForKey:UserPassword]];
                [self.navigationController pushViewController:distribution animated:YES];
            };
        });
    }
}

#pragma mark- 判断有无网络环境
static bool isnetFirst=NO;
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
        if (!isnetFirst) {
            isnetFirst=YES;
        }else{
            [self.BDScrollView.header endRefreshing];
        }
        return NO;
    }
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

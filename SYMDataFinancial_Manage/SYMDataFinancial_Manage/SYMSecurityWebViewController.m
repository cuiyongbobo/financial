//
//  SYMSecurityWebViewController.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/27.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMSecurityWebViewController.h"
#import "SYMConstantCenter.h"
#import "SYMTabController.h"

@interface SYMSecurityWebViewController ()
{
    UIImageView *_TitleImage;
    UILabel *payamount;
    UILabel *companyAccount;
}
@end

@implementation SYMSecurityWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationView];
    if ([[NSString stringWithFormat:@"%@",self.model.pageMode] isEqualToString:@"0"]) {
        // form表单
        NSString *urlString = [NSString stringWithFormat:@"%@",self.model.url];
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *postBody = [NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"req_data=%@",[NSString stringWithFormat:@"%@",self.model.req_data]] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postBody];
        [self.BDWebView loadRequest:request];
        
    }else if ([[NSString stringWithFormat:@"%@",self.model.pageMode] isEqualToString:@"1"]){
        // html 展示
        [self.BDWebView loadHTMLString:self.model.req_data baseURL:nil];
    }
}


-(void)initNavigationView
{
    [self.navigationController.navigationBar setHidden:NO];
    _TitleImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _TitleImage.image=[UIImage imageNamed:@""];
    self.navigationItem.titleView=_TitleImage;
    companyAccount=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _TitleImage.frame.size.width, 20)];
    companyAccount.text=@"连连支付";
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SYMTabController *tabself=(SYMTabController *)self.navigationController.tabBarController;
    [tabself hidenTabBar:YES];
    [self.changebutton setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SYMTabController *tabself=(SYMTabController *)self.navigationController.tabBarController;
    [tabself hidenTabBar:NO];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark- webViewDelegate

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    // NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('req_data')[0].value='';",self.description];
    // NSLog(@"self.BDWebView==%@", [self.BDWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('inputForm')[0].submit();"]);
    //[self.BDWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('inputForm')[0].submit();"];
}


-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlstr = request.URL.absoluteString;
    NSLog(@"url=%@",urlstr);
    NSString *str = @"buyCallback";
    //在str1这个字符串中搜索\n，判断有没有
    if ([urlstr rangeOfString:str].location != NSNotFound) {
        NSLog(@"拦截到");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.changebutton setHidden:NO];
        });
        //[self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.8f];
    }
    
    //    NSRange range = [urlstr rangeOfString:@"buyCallback"];
    //    if(range.length!=0)
    //    {
    //        NSLog(@"拦截到");
    //         NSString *method = [urlstr substringFromIndex:(range.location+range.length)];
    //         SEL selctor = NSSelectorFromString(method);
    //         [self performSelector:selctor withObject:nil];
    //    }
    
    return YES;
}


// js 调用oc
-(void)openMyAlbum
{
    
    //    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    //    vc.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
    //    [self presentViewController:vc animated:YES completion:nil];
    
    
}


// oc 调用js
-(void)openMyCamera

{
    [self.BDWebView stringByEvaluatingJavaScriptFromString:@"test();"];
    //return;
    
    //    UIImagePickerController*vc = [[UIImagePickerController alloc]init];
    //    vc.sourceType= UIImagePickerControllerSourceTypeCamera;
    //    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}

#pragma mark-延迟
-(void)delayMethod
{
    [self.changebutton setHidden:NO];
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

- (IBAction)btnClick:(id)sender {
    NSLog(@"跳转到我的资产");
    // 更换用户类型变成老用户
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:UserType];
    [[NSUserDefaults standardUserDefaults]synchronize];
    SYMTabController *myTab = (SYMTabController *)self.tabBarController;
    [myTab setCurrentSelectIndex:2];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end

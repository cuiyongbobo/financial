//
//  SharePlatform.m
//  BitMainWallet_Hot
//
//  Created by cuiyong on 15/6/16.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import "SharePlatform.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "UMSocialSinaSSOHandler.h"
#import "SYMPublicDictionary.h"
#import "SYMAFNHttp.h"
#import "SYMConstantCenter.h"
#import "MyTipsWindow.h"
#import "UIImageView+WebCache.h"

#define UmsercesKey @"56776c0667e58eac5e003d38"

@interface SharePlatform ()<UMSocialUIDelegate>
@end

@implementation SharePlatform

-(void)initShare
{
    NSString *infomessage=@"好基友来投资，额外收益+返现";
    //NSString *strUrl=[self.qrAddress stringByReplacingOccurrencesOfString:@"//" withString:@"%2F%2F"];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmsercesKey];
    
    // 添加微信及朋友圈
    [UMSocialWechatHandler setWXAppId:@"wx7daab438b6ea6ef8" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:self.backUrl];
    
    // 设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105027690" appKey:@"oStTfEWFPCunEAo3" url:self.backUrl];
    
    // 添加新浪微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2581215475" RedirectURL:self.backUrl];
    
    [UMSocialData openLog:YES];
    [UMSocialData defaultData].extConfig.title =infomessage;
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
}

-(void)showShare:(id)shareViewController
{
    _addressImage=[[UIImageView alloc]init];
    [_addressImage sd_setImageWithURL:[NSURL URLWithString:@"http://123.57.248.253/static/images/my-invite.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            [UMSocialSnsService presentSnsIconSheetView:shareViewController
                                                 appKey:UmsercesKey
                                              shareText:self.qrAddress
                                             shareImage:_addressImage.image
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]
                                               delegate:shareViewController];
        }
    }];
}

@end

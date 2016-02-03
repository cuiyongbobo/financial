//
//  SYMConstantCenter.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/3.
//  Copyright (c) 2015年 symdata. All rights reserved.
//

#ifndef SYMDataFinancial_Manage_SYMConstantCenter_h
#define SYMDataFinancial_Manage_SYMConstantCenter_h

/**
 *  蓝色背景
 */
#define SYMBLUECOLOR [UIColor colorWithRed:66/255.0f green:170/255.0f blue:229/255.0f alpha:1]
#define SYMBDClolor  [UIColor colorWithRed:233/255.0f green:242/255.0f blue:251/255.0f alpha:1]
#define SYMFontColor [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]
#define BTMBLUECOLOR [UIColor colorWithRed:0/255.0f green:91/255.0f blue:148/255.0f alpha:1]
#define SYMTabBarColor [UIColor colorWithRed:245/255.0f green:249/255.0f blue:253/255.0f alpha:1]
#define SYMLightGreyColor [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1]
#define SYMFontblackColor [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]
/**
 *  屏幕的宽
 */
#define BTMWidth [[UIScreen mainScreen] bounds].size.width
#define BTMHeight [[UIScreen mainScreen] bounds].size.height
/**
 *  tableViewCell
 */
#define OTHERADDRESSTABLEVIEWCELL_HEIGHT 333  // 317
#define RegularTABLEVIEWCELL_HEIGHT 187  // 170
#define MYADDRESSTABLEVIEWFOOTER_HEIGHT 35.0
#define TOTALTABLEVIEWHEIGHT (BTMHeight - 64 - 59 - 18 - 40)
/**
 *  ios系统
 */
#define iOS7 ([[[UIDevice currentDevice] systemVersion]floatValue]>=7) && ([[[UIDevice currentDevice] systemVersion]floatValue]<8)
#define iOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8
#define iOS7More [[[UIDevice currentDevice] systemVersion]floatValue]>=7

/**
 *  比例
 */
#define SYMHEIGHTRATESCALE (BTMHeight>568?BTMHeight/568:1)
#define SYMWIDthRATESCALE (BTMWidth/320)
/**
 *  图片比例
 */
#define KSImageScale 0.5

/**
 *  设置分页数
 */
#define kIMGCOUNT 2
/**
 *  用户信息
 */
#define ISLogIN @"longin"                   // 是否登录UserID
#define UserType @"usertype"                // 用户类型
#define ISdistribution @"distribution"      // 是否享有分销收益
#define IPhonenumber @"phoneNO"             // 用户手机号
#define UserPassword @"userpassword"        // 是否设置过登录密码
#define SETPasswordStatus @"paypassstatus"  // 设置支付密码状态
#define LoginPage @"longpage"               // 手势登录页
#define ForgetPassword @"forgetpassword"    // 忘记手势密码
#define EnterApplication @"enterapp"                // 进入应用
/**
 *  返回通知
 */
#define ReturnData @"returndata"
#define RegisteredSuccess @"Registeredsuccessful"

/**
 *  接口通用参数
 */
#define channelCodekey          @"channelCode"
#define channelCodeValues       @"HLC"
#define terminalTypekey         @"terminalType"
#define terminalTypeVlues       2
#define requestVersionkey       @"requestVersion"
#define requestVersionValues    @"ios1.0"

/**
 *  服务域名
 */
#if 0
#define SYMDATAAPI @"http://192.168.2.135:8080/uap_server"
#endif


#if 1
#define SYMDATAAPI @"http://123.56.102.141/uap_server"
#endif
/**
 *  测试服务域名
 */
// 192.168.2.135:8080/uap_server/p2pCashAll
#define SYMTestDATAAPI @"http://192.168.2.135:8080/uap_server"

/**
 *  banner图片域名
 */
#define SYMBannerAPI @"http://123.57.248.253/data"

/**
 *  业务接口
 */
/**
 *  用户注册
 */
#define SYMUserRegistration_URL [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/register"]

/**
 *  用户登录
 */
#define SYMUserLogin_URL [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/login"]

/**
 *  获取个人活动-获取banner
 */
#define SYMPersonalActivities_URL [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/contentPosition/findByContentPositionId"]
/**
 *  产品列表
 */
#define SYMProductList_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/product/findProductLists"]
/**
 *  终端收益
 */
#define SYMTerminalEarning_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/product/findTerminalProfitLists"]

/**
 *  买家收益
 */
#define SYMBuyersEarning_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/product/findPurchaserProfitLists"]

/**
 *  产品详情
 */
#define SYMProductDetails_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/product/findProductDetail"]

/**
 *  起息日期
 */
#define SYMInterestRates_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/product/interestMethod"]

/**
 *  选择银行卡
 */
#define SYMBankChosse_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/findBankChosse"]

/**
 *  检测手机号 
 */
#define SYMDetectionIphoneNumber_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/checkMobile"]

/**
 *  获取手机验证码
 */
#define SYMGetIphoneNumber_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/sendMobileCode"]

/**
 *  开户帮卡
 */
#define SYMOpenAccountCard_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/isBankOpen"]

/**
 *  支付密码校验
 */
#define SYMPasswordChecking_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/checkPayPwd"]

/**
 *  设置支付密码
 */
#define SYMSetPayPassWord_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/resetPwd"]

/**
 *  购买接口
 */
#define SYMBuyProduct_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/productBuy"]
//#define SYMBuyProduct_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/iosProductBuy"]
/**
 *  我的资产
 */
#define SYMMyAssets_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/asset/findMyAssets"]

/**
 *  交易记录 findNewOrderLists
 */
//#define SYMTransactionRecords_URL  [NSString stringWithFormat:@"%@%@",SYMTestDATAAPI,@"/asset/findOrderLists"]
#define SYMTransactionRecords_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/asset/findNewOrderLists"]

/**
 *  定期理财
 */
#define SYMRegularbasisFinancial_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/asset/findFixedAssets"]

/**
 *  定期提现查询
 */
#define SYMRegularWithdrawalQuery_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/asset/findCashMoney"]

/**
 *  定期提现接口
 */
#define SYMRegularWithdrawal_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/p2pCashAll"]

/**
 *  省份接口
 */
#define SYMProvinceList_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/findProvinceList"]

/**
 *  城市接口
 */
#define SYMCityList_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/findCtiyList"]

/**
 *  续投状态
 */
#define SYMregularMoneyInvestmentOrRedeem_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/asset/regularMoneyInvestmentOrRedeem"]
/**
 *  获取个人信息
 */
#define SYMpersonalInformation_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/findUserByUserParams"]

/**
 *  获取绑定银行卡
 */
#define SYMBingBankCard_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/findUserOpenAccountListsByUserId"]

/**
 *  用户反馈
 */
#define SYMFeedback_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/feedBack"]

/**
 *  检测登录原始密码
 */
#define SYMOldLoginPwdback_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/user/findOldPwdByUserIdAndOldPwd"]

/**
 *  拼接生成短连接
 */
#define SYMShareback_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/matchUrl"]

/**
 *  分享url接口
 */
#define SYMFindLongUrlback_URL  [NSString stringWithFormat:@"%@%@",SYMDATAAPI,@"/findLongUrlByShortUrl"]


#endif

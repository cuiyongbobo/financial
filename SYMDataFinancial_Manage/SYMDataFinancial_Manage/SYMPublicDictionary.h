//
//  SYMPublicDictionary.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/6.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMPublicDictionary : NSObject
/**
 *  单利方法
 *
 *  @return shareDictionary
 */
+(SYMPublicDictionary *)shareDictionary;
-(BOOL)judgeString:(NSString *)string;
-(BOOL)judgeArray:(NSArray *)array;
/**
 *  用户注册
 */
-(NSMutableDictionary *)joinPublicDictnary:(NSString *)mobile loginPwd:(NSString *)loginPwd checkNo:(NSString *)checkNo mac:(NSString *)mac source:(int)source appVersion:(NSString *)appVersion terminal:(NSString *)terminal imei:(NSString *)imei brand:(NSString *)brand telModel:(NSString *)telModel plmn:(NSString *)plmn inviteCode:(NSString *)inviteCode invitationCode:(NSString *)invitationCode invitationUrl:(NSString *)invitationUrl;

/**
 *  个人活动
 */
-(NSMutableDictionary *)personalActivitiesPublicDictnary:(NSString *)contentPositionId;
/**
 *  产品列表
 */
-(NSMutableDictionary *)ProductListPublicDictnary:(NSString *)productCatCode productCode:(NSString *)productCode distributorCode:(NSString *)distributorCode positionId:(NSString *)positionId;
/**
 *  终端收益
 */
-(NSMutableDictionary *)TerminalEarningPublicDictnary:(NSString *)productCatCode;

/**
 *  买家收益
 */
-(NSMutableDictionary *)BuyersEarningPublicDictnary:(NSString *)productCatCode PurchaserType:(int)purchaserType;
/**
 *  产品详情
 */
-(NSMutableDictionary *)ProductDetailsPublicDictnary:(NSString *)productCode PurchaserType:(int)purchaserType productCatCode:(NSString *)ProductCatCode;
/**
 *  起息日期
 */
-(NSMutableDictionary *)payoutDatePublicDictnary:(NSString *)productCode;

/**
 *  选择银行卡
 */
-(NSMutableDictionary *)BankChoosePublicDictnary:(NSString *)userId distributorCode:(NSString *)distributorCode;

/**
 *  检测手机号
 */
-(NSMutableDictionary *)detectionIPhoneNumberPublicDictnary:(NSString *)IPhoneNumber;

/**
 *  获取验证码
 */
-(NSMutableDictionary *)getIPhoneNumberPublicDictnary:(NSString *)IPhoneNumber;

/**
 *  登录
 */
-(NSMutableDictionary *)UserLoginPublicDictnary:(NSString *)IPhoneNumber loginPwd:(NSString *)loginPwd;

/**
 *  开户
 */
-(NSMutableDictionary *)OpenAccountPublicDictnary:(NSString *)userId distributorCode:(NSString *)distributorCode;

/**
 *  支付密码校验
 */
-(NSMutableDictionary *)PasswordCheckingPublicDictnary:(NSString *)userId distributorCode:(NSString *)payPwd;

/**
 *  登录密码校验
 */
-(NSMutableDictionary *)LoginPasswordCheckingPublicDictnary:(NSString *)userId distributorCode:(NSString *)payPwd;
/**
 *  设置支付密码
 */
-(NSMutableDictionary *)SetPayPasswordPublicDictnary:(NSString *)userId pwdType:(int)pwdType mobile:(NSString *)mobile loginPwd:(NSString *)loginPwd cashPwd:(NSString *)cashPwd;

/**
 *  购买产品
 */
-(NSMutableDictionary *)PayProductPublicDictnary:(NSString *)userId distributorCode:(NSString *)distributorCode isIndividual:(NSString *)isIndividual productCode:(NSString *)productCode amount:(NSString *)amount investorName:(NSString *)investorName certType:(NSString *)certType idCardNo:(NSString *)idCardNo bankCode:(NSString *)bankCode bankName:(NSString *)bankName cardNo:(NSString *)cardNo mobilePhone:(NSString *)mobilePhone buyMode:(NSString *)buyMode custNo:(NSString *)custNo isInvestAgain:(NSString *)isInvestAgain payMode:(NSString *)payMode invitecode:(NSString *)invitecode reserve1:(NSString *)reserve1 reserve2:(NSString *)reserve2 reserve3:(NSString *)reserve3 reserve4:(NSString *)reserve4 reserve5:(NSString *)reserve5 orderNo:(NSString *)orderNo;

/**
 *  我的资产
 */
-(NSMutableDictionary *)MyAssetsPublicDictnary:(NSString *)userId;

/**
 *  交易记录
 */
-(NSMutableDictionary *)TransactionRecordsPublicDictnary:(NSString *)userId transType:(int)transType pages:(int)pages rows:(int)rows;

/**
 *  定期提现拼接参数
 */
-(NSMutableDictionary *)RegularWithdrawalparameterPublicDictnary:(NSString *)distributorCode userId:(NSString *)userId amount:(NSString *)amount province:(NSString *)province city:(NSString *)city locusName:(NSString *)locusName;

/**
 *  定期提现
 */
-(NSMutableDictionary *)RegularWithdrawalPublicDictnary:(NSString *)cashVoList;
/**
 *  省份
 */
-(NSMutableDictionary *)ProvincePublicDictnary:(NSString *)distributorCode;

/**
 *  城市
 */
-(NSMutableDictionary *)CityPublicDictnary:(NSString *)distributorCode provinceCode:(NSString *)provinceCode;

-(NSMutableDictionary *)InvestmentOrRedeemPublicDictnary:(NSString *)orderId expireProcessMode:(NSString *)expireProcessMode;
/**
 *  用户反馈
 */
-(NSMutableDictionary *)UserfeedbackPublicDictnary:(NSString *)userID content:(NSString *)content email:(NSString *)email;

/**
 *  获取短连接
 */
-(NSMutableDictionary *)ShareUrlbackPublicDictnary:(NSString *)userID longUrl:(NSString *)longUrl;

/**
 *  获取分享url
 */
-(NSMutableDictionary *)FindLongUrlbackPublicDictnary:(NSString *)userID shorturl:(NSString *)shorturl;

@end

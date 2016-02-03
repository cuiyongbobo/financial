//
//  SYMDataBaseModel.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/27.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMDataBaseModel : NSObject
@end

@interface FinancialSupermarket : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *contentId;
@property (nonatomic,copy) NSString *contentType;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *linkUrl;
@property (nonatomic,copy) NSString *orders;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *showType;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *title;
@end

@interface ProductList : NSObject
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *minInvest;
@property (nonatomic,copy) NSString *standardProfit;
@property (nonatomic,copy) NSString *rate;
@property (nonatomic,copy) NSString *period;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *expandProfit;
@property (nonatomic,copy) NSString *productCatCode;
@property (nonatomic,copy) NSString *productType;
@property (nonatomic,copy) NSString *remaining;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *TagName;
@property (nonatomic,copy) NSString *sellStatus;
@property (nonatomic,copy) NSString *terminalProfit;
@property (nonatomic,copy) NSString *purchaserProfit;
@property (nonatomic,copy) NSString *purchaserType;
@property (nonatomic,copy) NSString *isdistribute;
@end

@interface ProductDetails : NSObject
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *standardProfit;
@property (nonatomic,copy) NSString *expandProfit;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *seld;
@property (nonatomic,copy) NSString *label1;
@property (nonatomic,copy) NSString *Label2;
@property (nonatomic,copy) NSString *Label3;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *period;
@property (nonatomic,copy) NSString *minInvest;
@property (nonatomic,copy) NSString *raiseInvest;
@property (nonatomic,copy) NSString *defaultExpireProcessMode;
@property (nonatomic,copy) NSString *rate;
@property (nonatomic,copy) NSString *riskLevel;
@property (nonatomic,copy) NSString *distributorCode;
@property (nonatomic,copy) NSString *terminalProfit;
@property (nonatomic,copy) NSString *purchaserProfit;
@property (nonatomic,copy) NSString *purchaserType;
@property (nonatomic,copy) NSString *isdistribute;
@property (nonatomic,copy) NSString *startAccrualDate;
@property (nonatomic,copy) NSString *endAccrualDate;
@property (nonatomic,copy) NSString *maxInvest;
@property (nonatomic,copy) NSString *remaining;
@property (nonatomic,copy) NSString *continuedInvestmentStatus;
@property (nonatomic,copy) NSString *productCatCode;
@end

@interface BankChoose : NSObject
@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *distributorCode;
@property (nonatomic,copy) NSString *isNote;
@property (nonatomic,copy) NSString *memo;
@property (nonatomic,copy) NSString *payBankCode;
@property (nonatomic,copy) NSString *payMode;
@property (nonatomic,copy) NSString *url;
@end

@interface OpenAccount : NSObject
@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *buyMode;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *contractNo;
@property (nonatomic,copy) NSString *custNo;
@property (nonatomic,copy) NSString *distributorCode;
@property (nonatomic,copy) NSString *idCardNo;
@property (nonatomic,copy) NSString *investorName;
@property (nonatomic,copy) NSString *isCashPwd;
@property (nonatomic,copy) NSString *isDefault;
@property (nonatomic,copy) NSString *isNote;
@property (nonatomic,copy) NSString *isReal;
@property (nonatomic,copy) NSString *isopenacct;
@property (nonatomic,copy) NSString *memo;
@property (nonatomic,copy) NSString *mobilePhone;
@property (nonatomic,copy) NSString *papersType;
@property (nonatomic,copy) NSString *payBankCode;
@property (nonatomic,copy) NSString *payMode;
@property (nonatomic,copy) NSString *tradeId;
@property (nonatomic,copy) NSString *userId;
@end

@interface CustomerInformation : NSObject
@property (nonatomic,copy) NSString *payamount;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *idCard;
@property (nonatomic,copy) NSString *bankcarName;
@property (nonatomic,copy) NSString *bankCarNo;
@property (nonatomic,copy) NSString *bankCode;
@end

@interface MyAsset : NSObject
@property (nonatomic,copy) NSString *currentAmount;
@property (nonatomic,copy) NSString *regularAmount;
@property (nonatomic,copy) NSString *totalAssets;
@property (nonatomic,copy) NSString *totalIncome;
@property (nonatomic,copy) NSString *yesterdayIncome; 
@end

@interface TransactionRecords : NSObject
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *businessType;
@property (nonatomic,copy) NSString *transType;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *spendTime;
@property (nonatomic,copy) NSString *amount; 
@property (nonatomic,copy) NSString *publishName;
@end

@interface RegularBasisList : NSObject
@property (nonatomic,copy) NSString *publishCode;
@property (nonatomic,copy) NSString *publishName;
@property (nonatomic,copy) NSString *productCode;
@property (nonatomic,copy) NSString *expctedEarning;
@property (nonatomic,copy) NSString *expireProcessMode;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *redemptionTime;
@property (nonatomic,copy) NSString *isInvestAgain;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *isHonor;
@property (nonatomic,copy) NSString *orderId;
@end

@interface ListCash : NSObject
@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *cashAvailable;
@property (nonatomic,copy) NSString *distributorCode;
@property (nonatomic,copy) NSString *distributorName;
@property (nonatomic,copy) NSString *withdrawalType;
@end

@interface Withdrawal : NSObject
@property (nonatomic,copy) NSString *distributorCode;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *locusName;
@end

@interface Province : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *name;
@end

@interface City : NSObject
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *cityCode;
@end

@interface WithdrawalResults : NSObject
@property (nonatomic,copy) NSString *cashMoney;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *toDate;
@end

@interface PersonalInformation : NSObject
@property (nonatomic,copy) NSString *idCardNo;
@property (nonatomic,copy) NSString *inviteCode;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *realName;
@end

@interface SelfBankCard : NSObject
@property (nonatomic,copy) NSString *bankCode;
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *cardNo;
@end

@interface Buyproduct : NSObject
@property (nonatomic,copy) NSString *pageMode;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *req_data;
@end

@interface UserInformation : NSObject
@property (nonatomic,copy) NSString *userId; 
@property (nonatomic,copy) NSString *gesturespassword;
@end












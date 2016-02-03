//
//  BtmSharePinPassWordViewController.h
//  BitMainWallet_Hot
//
//  Created by cuiyong on 15/6/22.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import "MainViewController.h"


typedef enum :NSInteger {
    isSendBTC=0,       // 支付
    isSeTPassword,     // 设置密码
    isInputPassword,   // 输入密码
    isTouchIDPassword, // touchid
    isNotReslName,     // 未实名认证
    isInviteCode,      // 邀请码
    isHelpCard,         // 未帮卡
    isTransactionrecords  // 交易记录
}Changetype;
typedef void (^BackPassblcok) (NSString *);
typedef void(^Requestback)(NSString *,NSString *);
typedef void (^BackCloseblock)(void);
typedef void (^ForgetPassblock)(void);
@interface BtmSharePinPassWordViewController : MainViewController
/**
 *  根据系统每个版本选择不同的model推出方式
 */
-(void)defaultStandPinPassword:(UIViewController *)viewcontroller;
@property (nonatomic,copy) BackPassblcok backPassword;
@property (nonatomic,copy) Requestback requestback;
@property (nonatomic,copy) BackCloseblock close;
@property (nonatomic,copy) ForgetPassblock forgetpassword;
@property (nonatomic,assign)BOOL isSendBTC;
@property (nonatomic,assign) NSInteger isinput;
@property (nonatomic,copy) NSString *sendmoney; // 发送金额
@property (nonatomic,copy) NSString *BankCardInformation; // 发送金额
@property (nonatomic,copy) NSString *DetailedInformation; // 发送金额
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *cardNo;
@property (nonatomic,copy) NSString *memo;

@end

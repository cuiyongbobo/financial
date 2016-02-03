//
//  SYMPublicDictionary.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/6.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMPublicDictionary.h"
#import "SYMConstantCenter.h"
#import "MD5Util.h"

@implementation SYMPublicDictionary


+(SYMPublicDictionary *)shareDictionary
{
    static SYMPublicDictionary *publicDict=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        publicDict=[[SYMPublicDictionary alloc]init];
    });
    return publicDict;
}

#pragma mark- 判断字符为空
-(BOOL)judgeString:(NSString *)string
{
    BOOL isresult=NO;
    if(string==nil)
    {
        isresult=YES;
    }
    //还有就是<null>，从网上找到了用法：
    if([string isEqual:[NSNull null]])
    {
        isresult=YES;
    }
    if ([NSString stringWithFormat:@"%@",string].length==0) {
        isresult=YES;
    }
    return  isresult;
}

#pragma mark- 判断数组为空
-(BOOL)judgeArray:(NSArray *)array
{
    BOOL isresult=NO;
    if (array!=nil && ![array isKindOfClass:[NSNull class]] && array.count!=0) {
        isresult=NO;
    }else{
        isresult=YES;
    }
    return isresult;
}

-(NSMutableDictionary *)joinPublicDictnary:(NSString *)mobile loginPwd:(NSString *)loginPwd checkNo:(NSString *)checkNo mac:(NSString *)mac source:(int)source appVersion:(NSString *)appVersion terminal:(NSString *)terminal imei:(NSString *)imei brand:(NSString *)brand telModel:(NSString *)telModel plmn:(NSString *)plmn inviteCode:(NSString *)inviteCode invitationCode:(NSString *)invitationCode invitationUrl:(NSString *)invitationUrl

{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL b=[self judgeString:mobile];
    if (b) {
        mobile=@"";
    }
    
    BOOL isc=[self judgeString:loginPwd];
    if (isc) {
        loginPwd=@"";
    }
    
    BOOL isd=[self judgeString:checkNo];
    if (isd) {
        checkNo=@"";
    }
    
    BOOL ise=[self judgeString:mac];
    if (ise) {
        mac=@"";
    }
    
    BOOL isf=[self judgeString:appVersion];
    if (isf) {
        appVersion=@"";
    }
    
    BOOL c=[self judgeString:terminal];
    if (c) {
        terminal=@"";
    }
    
    BOOL d=[self judgeString:imei];
    if (d) {
        imei=@"";
    }
    
    BOOL e=[self judgeString:brand];
    if (e) {
        brand=@"";
    }
    
    BOOL issa=[self judgeString:telModel];
    if (issa) {
        telModel=@"";
    }
    
    BOOL issb=[self judgeString:plmn];
    if (issb) {
        plmn=@"";
    }
    
    BOOL issc=[self judgeString:inviteCode];
    if (issc) {
        inviteCode=@"";
    }
    
    BOOL issd=[self judgeString:invitationCode];
    if (issd) {
        invitationCode=@"";
    }
    
    BOOL isse=[self judgeString:invitationUrl];
    if (isse) {
        invitationUrl=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:mobile forKey:@"mobile"];
    [paramDict setObject:[MD5Util md532BitUpper:loginPwd] forKey:@"loginPwd"];
    [paramDict setObject:checkNo forKey:@"checkNo"];
    [paramDict setObject:mac forKey:@"mac"];
    [paramDict setObject:[NSNumber numberWithInt:source] forKey:@"source"];
    [paramDict setObject:appVersion forKey:@"appVersion"];
    [paramDict setObject:terminal forKey:@"terminal"];
    [paramDict setObject:imei forKey:@"imei"];
    [paramDict setObject:brand forKey:@"brand"];
    [paramDict setObject:telModel forKey:@"telModel"];
    [paramDict setObject:plmn forKey:@"plmn"];
    [paramDict setObject:inviteCode forKey:@"inviteCode"];
    [paramDict setObject:invitationCode forKey:@"invitationCode"];
    [paramDict setObject:invitationUrl forKey:@"invitationUrl"];
    return paramDict;
}

-(NSMutableDictionary *)personalActivitiesPublicDictnary:(NSString *)contentPositionId{
    BOOL b=[self judgeString:contentPositionId];
    if (b) {
        contentPositionId=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:contentPositionId forKey:@"contentPositionId"];
    return paramDict;
}


-(NSMutableDictionary *)ProductListPublicDictnary:(NSString *)productCatCode productCode:(NSString *)productCode distributorCode:(NSString *)distributorCode positionId:(NSString *)positionId{
    BOOL isb=[self judgeString:productCatCode];
    if (isb) {
        productCatCode=@"";
    }
    
    BOOL isc=[self judgeString:productCode];
    if (isc) {
        productCode=@"";
    }
    
    BOOL isd=[self judgeString:distributorCode];
    if (isd) {
        distributorCode=@"";
    }
    
    BOOL ise=[self judgeString:positionId];
    if (ise) {
        positionId=@"";
    }
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:productCatCode forKey:@"productCatCode"];
    [paramDict setObject:productCode forKey:@"productCode"];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    [paramDict setObject:positionId forKey:@"positionId"];
    return paramDict;
}


-(NSMutableDictionary *)TerminalEarningPublicDictnary:(NSString *)productCatCode{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL isb=[self judgeString:productCatCode];
    if (isb) {
        productCatCode=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:productCatCode forKey:@"productCatCode"];
    return paramDict;
}

-(NSMutableDictionary *)BuyersEarningPublicDictnary:(NSString *)productCatCode PurchaserType:(int)purchaserType{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL isb=[self judgeString:productCatCode];
    if (isb) {
        productCatCode=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:[NSNumber numberWithInt:purchaserType] forKey:@"purchaserType"];
    [paramDict setObject:productCatCode forKey:@"productCatCode"];
    return paramDict;
}


-(NSMutableDictionary *)ProductDetailsPublicDictnary:(NSString *)productCode PurchaserType:(int)purchaserType productCatCode:(NSString *)ProductCatCode
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL isb=[self judgeString:productCode];
    if (isb) {
        productCode=@"";
    }
    BOOL isc=[self judgeString:ProductCatCode];
    if (isc) {
        ProductCatCode=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:productCode forKey:@"productCode"];
    [paramDict setObject:[NSNumber numberWithInt:purchaserType] forKey:@"purchaserType"];
    [paramDict setObject:ProductCatCode forKey:@"productCatCode"];
    return paramDict;
}

-(NSMutableDictionary *)payoutDatePublicDictnary:(NSString *)productCode
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL isb=[self judgeString:productCode];
    if (isb) {
        productCode=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:productCode forKey:@"productCode"];
    return paramDict;
}

-(NSMutableDictionary *)BankChoosePublicDictnary:(NSString *)userId distributorCode:(NSString *)distributorCode
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL isb=[self judgeString:userId];
    if (isb) {
        userId=@"";
    }
    BOOL isc=[self judgeString:distributorCode];
    if (isc) {
        distributorCode=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    return paramDict;
}

-(NSMutableDictionary *)detectionIPhoneNumberPublicDictnary:(NSString *)IPhoneNumber
{
    BOOL b=[self judgeString:IPhoneNumber];
    if (b) {
        IPhoneNumber=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:IPhoneNumber forKey:@"mobile"];
    return paramDict;
}


-(NSMutableDictionary *)getIPhoneNumberPublicDictnary:(NSString *)IPhoneNumber
{
    BOOL b=[self judgeString:IPhoneNumber];
    if (b) {
        IPhoneNumber=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:IPhoneNumber forKey:@"mobile"];
    return paramDict;
}

-(NSMutableDictionary *)UserLoginPublicDictnary:(NSString *)IPhoneNumber loginPwd:(NSString *)loginPwd
{
    BOOL b=[self judgeString:IPhoneNumber];
    if (b) {
        IPhoneNumber=@"";
    }
    
    BOOL isb=[self judgeString:loginPwd];
    if (isb) {
        loginPwd=@"";
    }
    
    NSLog(@"[MD5Util md5:loginPwd]=%@",[MD5Util md532BitUpper:loginPwd]);
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:IPhoneNumber forKey:@"mobile"];
    [paramDict setObject:[MD5Util md532BitUpper:loginPwd] forKey:@"loginPwd"];
    return paramDict;
}

-(NSMutableDictionary *)OpenAccountPublicDictnary:(NSString *)userId distributorCode:(NSString *)distributorCode
{
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    BOOL isb=[self judgeString:distributorCode];
    if (isb) {
        distributorCode=@"";
    }
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    return paramDict;
}

-(NSMutableDictionary *)PasswordCheckingPublicDictnary:(NSString *)userId distributorCode:(NSString *)payPwd
{
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    BOOL isb=[self judgeString:payPwd];
    if (isb) {
        payPwd=@"";
    }
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:[MD5Util md532BitUpper:payPwd] forKey:@"payPwd"];
    return paramDict;
}

-(NSMutableDictionary *)LoginPasswordCheckingPublicDictnary:(NSString *)userId distributorCode:(NSString *)payPwd{
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    BOOL isb=[self judgeString:payPwd];
    if (isb) {
        payPwd=@"";
    }
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:[MD5Util md532BitUpper:payPwd] forKey:@"oldLoginPwd"];
    return paramDict;
}

-(NSMutableDictionary *)SetPayPasswordPublicDictnary:(NSString *)userId pwdType:(int)pwdType mobile:(NSString *)mobile loginPwd:(NSString *)loginPwd cashPwd:(NSString *)cashPwd
{
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    BOOL isb=[self judgeString:mobile];
    if (isb) {
        mobile=@"";
    }
    BOOL isc=[self judgeString:loginPwd];
    if (isc) {
        loginPwd=@"";
    }
    
    BOOL isd=[self judgeString:cashPwd];
    if (isd) {
        cashPwd=@"";
    }
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:[NSNumber numberWithInt:pwdType] forKey:@"pwdType"];
    [paramDict setObject:mobile forKey:@"mobile"];
    [paramDict setObject:[MD5Util md532BitUpper:loginPwd] forKey:@"loginPwd"];
    [paramDict setObject:[MD5Util md532BitUpper:cashPwd] forKey:@"cashPwd"];
    return paramDict;
}

-(NSMutableDictionary *)PayProductPublicDictnary:(NSString *)userId distributorCode:(NSString *)distributorCode isIndividual:(NSString *)isIndividual productCode:(NSString *)productCode amount:(NSString *)amount investorName:(NSString *)investorName certType:(NSString *)certType idCardNo:(NSString *)idCardNo bankCode:(NSString *)bankCode bankName:(NSString *)bankName cardNo:(NSString *)cardNo mobilePhone:(NSString *)mobilePhone buyMode:(NSString *)buyMode custNo:(NSString *)custNo isInvestAgain:(NSString *)isInvestAgain payMode:(NSString *)payMode invitecode:(NSString *)invitecode reserve1:(NSString *)reserve1 reserve2:(NSString *)reserve2 reserve3:(NSString *)reserve3 reserve4:(NSString *)reserve4 reserve5:(NSString *)reserve5 orderNo:(NSString *)orderNo
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    BOOL isc=[self judgeString:distributorCode];
    if (isc) {
        distributorCode=@"";
    }
    
    BOOL isd=[self judgeString:isIndividual];
    if (isd) {
        isIndividual=@"";
    }
    
    BOOL ise=[self judgeString:productCode];
    if (ise) {
        productCode=@"";
    }
    
    BOOL isf=[self judgeString:amount];
    if (isf) {
        amount=@"";
    }
    
    BOOL c=[self judgeString:investorName];
    if (c) {
        investorName=@"";
    }
    
    BOOL d=[self judgeString:certType];
    if (d) {
        certType=@"";
    }
    
    BOOL e=[self judgeString:idCardNo];
    if (e) {
        idCardNo=@"";
    }
    
    BOOL issa=[self judgeString:bankCode];
    if (issa) {
        bankCode=@"";
    }
    
    BOOL issb=[self judgeString:bankName];
    if (issb) {
        bankName=@"";
    }
    
    BOOL issc=[self judgeString:cardNo];
    if (issc) {
        cardNo=@"";
    }
    
    BOOL issd=[self judgeString:mobilePhone];
    if (issd) {
        mobilePhone=@"";
    }
    
    BOOL isse=[self judgeString:buyMode];
    if (isse) {
        buyMode=@"";
    }
    
    BOOL isssa=[self judgeString:custNo];
    if (isssa) {
        custNo=@"";
    }
    
    BOOL isssb=[self judgeString:isInvestAgain];
    if (isssb) {
        isInvestAgain=@"0";
    }
    
    BOOL issse=[self judgeString:payMode];
    if (issse) {
        payMode=@"";
    }
    
    BOOL isssf=[self judgeString:invitecode];
    if (isssf) {
        invitecode=@"";
    }
    
    BOOL issaa=[self judgeString:reserve1];
    if (issaa) {
        reserve1=@"";
    }
    
    BOOL issab=[self judgeString:reserve2];
    if (issab) {
        reserve2=@"";
    }
    
    BOOL issac=[self judgeString:reserve3];
    if (issac) {
        reserve3=@"";
    }
    
    BOOL issad=[self judgeString:reserve4];
    if (issad) {
        reserve4=@"";
    }
    
    BOOL issae=[self judgeString:reserve5];
    if (issae) {
        reserve5=@"";
    }
    
    BOOL issaf=[self judgeString:orderNo];
    if (issaf) {
        orderNo=@"";
    }
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    [paramDict setObject:isIndividual forKey:@"isIndividual"];
    [paramDict setObject:productCode forKey:@"productCode"];
    [paramDict setObject:amount forKey:@"amount"];
    [paramDict setObject:investorName forKey:@"investorName"];
    [paramDict setObject:certType forKey:@"certType"];
    [paramDict setObject:idCardNo forKey:@"idCardNo"];
    [paramDict setObject:bankCode forKey:@"bankCode"];
    [paramDict setObject:bankName forKey:@"bankName"];
    [paramDict setObject:cardNo forKey:@"cardNo"];
    [paramDict setObject:mobilePhone forKey:@"mobilePhone"];
    [paramDict setObject:buyMode forKey:@"buyMode"];
    [paramDict setObject:custNo forKey:@"custNo"];
    [paramDict setObject:isInvestAgain forKey:@"isInvestAgain"];
    [paramDict setObject:payMode forKey:@"payMode"];
    [paramDict setObject:invitecode forKey:@"invitecode"];
    [paramDict setObject:reserve1 forKey:@"reserve1"];
    [paramDict setObject:reserve2 forKey:@"reserve2"];
    [paramDict setObject:reserve3 forKey:@"reserve3"];
    [paramDict setObject:reserve4 forKey:@"reserve4"];
    [paramDict setObject:reserve5 forKey:@"reserve5"];
    [paramDict setObject:orderNo forKey:@"orderNo"];
    
    return paramDict;
}

-(NSMutableDictionary *)MyAssetsPublicDictnary:(NSString *)userId
{
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    return paramDict;
}

-(NSMutableDictionary *)TransactionRecordsPublicDictnary:(NSString *)userId transType:(int)transType pages:(int)pages rows:(int)rows
{
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:[NSNumber numberWithInt:transType] forKey:@"transType"];
    [paramDict setObject:[NSNumber numberWithInt:pages] forKey:@"pages"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    return paramDict;
}

-(NSMutableDictionary *)RegularWithdrawalparameterPublicDictnary:(NSString *)distributorCode userId:(NSString *)userId amount:(NSString *)amount province:(NSString *)province city:(NSString *)city locusName:(NSString *)locusName
{
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL b=[self judgeString:userId];
    if (b) {
        userId=@"";
    }
    
    BOOL isc=[self judgeString:distributorCode];
    if (isc) {
        distributorCode=@"";
    }
    
    BOOL isd=[self judgeString:province];
    if (isd) {
        province=@"";
    }
    
    BOOL ise=[self judgeString:city];
    if (ise) {
        city=@"";
    }
    
    BOOL isf=[self judgeString:amount];
    if (isf) {
        amount=@"";
    }
    
    BOOL d=[self judgeString:locusName];
    if (d) {
        locusName=@"";
    }
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    [paramDict setObject:province forKey:@"province"];
    [paramDict setObject:city forKey:@"city"];
    [paramDict setObject:amount forKey:@"amount"];
    [paramDict setObject:locusName forKey:@"locusName"];
    return paramDict;
}

-(NSMutableDictionary *)RegularWithdrawalPublicDictnary:(NSString *)cashVoList
{
    BOOL b=[self judgeString:cashVoList];
    if (b) {
        cashVoList=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:cashVoList forKey:@"cashVoList"];
    return paramDict;
}

-(NSMutableDictionary *)ProvincePublicDictnary:(NSString *)distributorCode
{
    BOOL b=[self judgeString:distributorCode];
    if (b) {
        distributorCode=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    return paramDict;
}

-(NSMutableDictionary *)CityPublicDictnary:(NSString *)distributorCode provinceCode:(NSString *)provinceCode
{
    BOOL b=[self judgeString:distributorCode];
    if (b) {
        distributorCode=@"";
    }
    BOOL c=[self judgeString:provinceCode];
    if (c) {
        provinceCode=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:distributorCode forKey:@"distributorCode"];
    [paramDict setObject:provinceCode forKey:@"provinceCode"];
    return paramDict;
}

-(NSMutableDictionary *)InvestmentOrRedeemPublicDictnary:(NSString *)orderId expireProcessMode:(NSString *)expireProcessMode
{
    BOOL b=[self judgeString:orderId];
    if (b) {
        orderId=@"";
    }
    BOOL c=[self judgeString:expireProcessMode];
    if (c) {
        expireProcessMode=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:orderId forKey:@"orderId"];
    [paramDict setObject:expireProcessMode forKey:@"expireProcessMode"];
    return paramDict;
}

-(NSMutableDictionary *)UserfeedbackPublicDictnary:(NSString *)userID content:(NSString *)content email:(NSString *)email
{
    BOOL b=[self judgeString:userID];
    if (b) {
        userID=@"";
    }
    BOOL c=[self judgeString:content];
    if (c) {
        content=@"";
    }
    BOOL d=[self judgeString:email];
    if (d) {
        email=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userID forKey:@"userId"];
    [paramDict setObject:content forKey:@"content"];
    [paramDict setObject:email forKey:@"email"];
    return paramDict;
}

-(NSMutableDictionary *)ShareUrlbackPublicDictnary:(NSString *)userID longUrl:(NSString *)longUrl
{
    BOOL b=[self judgeString:userID];
    if (b) {
        userID=@"";
    }
    BOOL c=[self judgeString:longUrl];
    if (c) {
        longUrl=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userID forKey:@"userId"];
    [paramDict setObject:longUrl forKey:@"longUrl"];
    return paramDict;
}

-(NSMutableDictionary *)FindLongUrlbackPublicDictnary:(NSString *)userID shorturl:(NSString *)shorturl
{
    BOOL b=[self judgeString:userID];
    if (b) {
        userID=@"";
    }
    BOOL c=[self judgeString:shorturl];
    if (c) {
        shorturl=@"";
    }
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]initWithCapacity:10];
    [paramDict setObject:channelCodeValues forKey:channelCodekey];
    [paramDict setObject:[NSNumber numberWithInt:terminalTypeVlues] forKey:terminalTypekey];
    [paramDict setObject:requestVersionValues forKey:requestVersionkey];
    [paramDict setObject:userID forKey:@"userId"];
    [paramDict setObject:shorturl forKey:@"shortUrl"];
    return paramDict;
    
}

- (BOOL)isPureInt:(NSString *)string
{
    NSScanner *scan=[NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


@end

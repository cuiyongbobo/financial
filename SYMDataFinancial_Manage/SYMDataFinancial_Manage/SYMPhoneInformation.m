//
//  SYMPhoneInformation.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/7.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMPhoneInformation.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import <CommonCrypto/CommonDigest.h>

@interface SYMPhoneInformation ()
@end

@implementation SYMPhoneInformation
+(SYMPhoneInformation *)sharePhoneInformation{
    static SYMPhoneInformation *phoneInformation=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phoneInformation=[[SYMPhoneInformation alloc]init];
    });
    return phoneInformation;
}
-(NSDictionary *)getinfo{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:10];
    //应用程序的名称和版本号等信息都保存在mainBundle的一个字典中，用下面代码可以取出来。
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    //应用版本(游戏版本)
    NSString * versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    //手机型号
    NSString *phoneModel=[self getCurrentDeviceModel];
    //设备名称
    NSString *deviceName=[[UIDevice currentDevice]systemName];
    //MAC（地址）
    NSString *MacAddress=[self macaddress];
    //PLMN
    /*
     中国移动的PLMN为46000，中国联通的PLMN为46001
     */
    NSString *Plmn=[self findPLMNCode];
    NSLog(@"plmn---->%@",Plmn);
    //获取imei
    NSString *imei=[self getImei];
    //获取运营商
    int operatorStr=[self operatorStr];
    
    BOOL b=[self judgeString:imei];
    if (b) {
        imei=@"";
    }
    
    BOOL isb=[self judgeString:Plmn];
    if (isb) {
        Plmn=@"";
    }
    
    BOOL isc=[self judgeString:MacAddress];
    if (isc) {
        MacAddress=@"";
    }
    
    BOOL isd=[self judgeString:deviceName];
    if (isd) {
        deviceName=@"";
    }
    
    BOOL ise=[self judgeString:phoneModel];
    if (ise) {
        phoneModel=@"";
    }
    
    BOOL isf=[self judgeString:versionNum];
    if (isf) {
        versionNum=@"";
    }
    
    //封装成字典
    [dict setObject:imei forKey:@"idfa"];
    [dict setObject:Plmn forKey:@"plmn"];
    [dict setObject:MacAddress forKey:@"macaddress"];
    [dict setObject:deviceName forKey:@"devicename"];
    [dict setObject:phoneModel forKey:@"phonemodel"];
    [dict setObject:versionNum forKey:@"versionnum"];
    [dict setObject:[NSString stringWithFormat:@"%d",operatorStr] forKey:@"operatorstr"];
    return dict;
}


#pragma mark -获取手机型号

- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    return @"未知";
}

#pragma mark- 获取运营商
/*运营商*/
-(int)operatorStr
{
    NSString *carrierStr=nil;
    int netType=0;
    CTTelephonyNetworkInfo *networkInfo=[[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier=networkInfo.subscriberCellularProvider;
    
    if (carrier) {
        if (carrier.mobileCountryCode) {
            if ([carrier.carrierName length]!=0) {
                carrierStr=carrier.carrierName;
                if ([carrier.carrierName isEqualToString:@"中国联通"]) {
                    netType=2;
                }else if ([carrier.carrierName isEqualToString:@"中国移动"]){
                    netType=1;
                    
                }else if ([carrier.carrierName isEqualToString:@"中国电信"]){
                    netType=3;
                }
            }
        }
    }
    return netType;
}

#pragma mark- IMEI
-(NSString *)getImei
{
    return  [self findIdfa];
}

#pragma mark- 获取mac 地址
-(NSString *)macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        //		printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

#pragma mark - 获取PLMNCode
-(NSString *)findPLMNCode
{
    CTTelephonyNetworkInfo *networkInfo=[[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier=networkInfo.subscriberCellularProvider;
    
    //[networkInfo release];
    networkInfo=nil;
    
    if (carrier) {
        if (carrier.mobileCountryCode && carrier.mobileNetworkCode) {
            if ([carrier.mobileCountryCode length]!=0 && [carrier.mobileNetworkCode length]!=0) {
                NSString *countrynetwork=[NSString stringWithFormat:@"%@%@",carrier.mobileCountryCode,carrier.mobileNetworkCode];
                return countrynetwork;
            }
        }
    }
    return @"";
}

#pragma mark - 获取Idfa
-(NSString *)findIdfa
{
    NSString *idfa;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    return idfa;
}

#pragma mark- 判断字符为空
-(BOOL)judgeString:(NSString *)string
{
    BOOL isresult=NO;
    if(string==nil)
    {
        NSLog(@"KDA!");
        isresult=YES;
    }
    //还有就是<null>，从网上找到了用法：
    if([string isEqual:[NSNull null]])
    {
        NSLog(@"KDA!");
        isresult=YES;
    }
    return  isresult;
}

@end

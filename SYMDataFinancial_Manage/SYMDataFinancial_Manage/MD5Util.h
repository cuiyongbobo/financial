//
//  StringUtil.h
//  FXTool
//
//  Created by 房杨平 on 11-8-18.
//  Copyright 2011 EmatChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> 

//md5 加密
@interface MD5Util : NSObject {

}

//+ (NSString *) md5:(NSString *)str;//加密字符串
+ (NSString *) md5ForFileContent:(NSString *)file;//加密文件内容
+ (NSString *) md5ForData:(NSData *)data;//加密data


+ (NSString*)md532BitLower:(NSString *)str;
+ (NSString*)md532BitUpper:(NSString *)str;

@end

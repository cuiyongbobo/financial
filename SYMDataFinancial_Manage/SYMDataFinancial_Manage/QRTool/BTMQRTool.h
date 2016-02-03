//
//  BTMQRTool.h
//  BitMainWallet_Hot
//
//  Created by xunianqiang on 15-1-23.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "QRCodeGenerator.h"
#import "ZBarSDK.h"

@interface BTMQRTool : NSObject<ZBarReaderViewDelegate>

@property (nonatomic,copy) void (^qrResult)(NSString *qrStr);//二维码扫描结果

//create QR code
+(UIImage *)createQRImageWithString:(NSString *)str  imageSize:(CGFloat)size withPointType:(QRPointType)pointType withPositionType:(QRPositionType)positionType withColor:(UIColor *)color;

//scan QR
/*扫描二维码部分：
 导入ZBarSDK文件并引入一下框架
 AVFoundation.framework
 CoreMedia.framework
 CoreVideo.framework
 QuartzCore.framework
 libiconv.dylib
 引入头文件#import “ZBarSDK.h” 即可使用
 */
-(void)scanQR:(id)controller isPirvkey:(NSInteger)isprv;//isprv 1为开启私钥扫描,0为不开启，2为从相册中导入二维码



//解析二维码字符串为地址私钥
+(NSArray *)parseQRResult:(NSString *)qrstr;
//解析二维码字符串是否为创建多重签名
+(NSString *)parseMultiSignCreateString:(NSString *)qrstr;
@end

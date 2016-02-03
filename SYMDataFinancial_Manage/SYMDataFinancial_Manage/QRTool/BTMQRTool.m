//
//  BTMQRTool.m
//  BitMainWallet_Hot
//
//  Created by xunianqiang on 15-1-23.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import "BTMQRTool.h"
#import "QRScanViewController.h"

//system
#define iOS7 ([[[UIDevice currentDevice] systemVersion]floatValue]>=7) && ([[[UIDevice currentDevice] systemVersion]floatValue]<8)
#define iOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8
#define iOS7More [[[UIDevice currentDevice] systemVersion]floatValue]>=7//ios 7以上
@implementation BTMQRTool

+(UIImage *)createQRImageWithString:(NSString *)str  imageSize:(CGFloat)size withPointType:(QRPointType)pointType withPositionType:(QRPositionType)positionType withColor:(UIColor *)color
{
    UIImage *image = [[UIImage alloc] init];
    image = [QRCodeGenerator qrImageForString:str imageSize:size withPointType:pointType withPositionType:positionType withColor:color];
    
    return image;
}

-(void)scanQR:(id)controller isPirvkey:(NSInteger)isprv
{
    if (iOS7More) {
        QRScanViewController *qr = [[QRScanViewController alloc]init];
        qr.qrResult_7 = ^(NSString *qrStr)
        {
            self.qrResult(qrStr);
        };
        qr.isprivkey = isprv;
        if (iOS8) {
            [controller presentViewController:qr animated:YES completion:nil];
        }
        else if (iOS7)
        {
            [controller presentViewController:qr animated:NO completion:nil];
        }
        
    }
    else{
        ZBarReaderViewController *reader = [[ZBarReaderViewController alloc]init];
        reader.readerDelegate = (id)controller;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
        [controller presentViewController:reader animated:YES completion:^{
//            NSLog(@"跳转成功");
        }];
    }

}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    NSLog(@"qr sucess");
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@",symbol.data);
    }
    
    [readerView stop];
}



//解析二维码字符串
+(NSArray *)parseQRResult:(NSString *)qrstr
{
    NSLog(@"%@",qrstr);
    //    bitcoin:1JoqQsb9haANEKHWPaVB4sxshRVnUZfiip?amount=0.17926000
    NSMutableArray *result = [[NSMutableArray alloc]init];
    //判断是否带金额
    if ([qrstr rangeOfString:@"bitcoin://"].location != NSNotFound) {
        //带金额的
        NSLog(@"what ?");
        NSMutableString *qrMuStr = [[NSMutableString alloc]initWithString:qrstr];
        
        NSRange colon = [qrstr rangeOfString:@"://"];
        NSRange interrogation = [qrstr rangeOfString:@"?"];
        NSRange equalSign = [qrstr rangeOfString:@"="];
        NSRange addrRange = {colon.location+3,interrogation.location-colon.location-3};
        NSString *aimAddr = [qrMuStr substringWithRange:addrRange];
        NSString *aimAmount = [qrMuStr substringFromIndex:equalSign.location+1];
        [result addObject:aimAddr];
        [result addObject:aimAmount];
        NSLog(@"%@",result);
    }
    else if ([qrstr rangeOfString:@"bitcoin:"].location != NSNotFound)
    {
        if ([qrstr rangeOfString:@"="].location != NSNotFound) {
            NSMutableString *qrMuStr = [[NSMutableString alloc]initWithString:qrstr];
            NSRange colon = [qrstr rangeOfString:@":"];
            NSRange interrogation = [qrstr rangeOfString:@"?"];
            NSRange equalSign = [qrstr rangeOfString:@"="];
            NSRange addrRange = {colon.location+1,interrogation.location-colon.location-1};
            NSString *aimAddr = [qrMuStr substringWithRange:addrRange];
            NSString *aimAmount = [qrMuStr substringFromIndex:equalSign.location+1];
            [result addObject:aimAddr];
            [result addObject:aimAmount];
        }
        else{
            NSMutableString *qrMuStr = [[NSMutableString alloc]initWithString:qrstr];
            NSRange colon = [qrstr rangeOfString:@":"];
            NSRange addrRange = {colon.location+1,qrMuStr.length-8};
            NSString *aimAddr = [qrMuStr substringWithRange:addrRange];
            [result addObject:aimAddr];
            
        }
        
    }

    else{
        //不带金额的
        [result addObject:qrstr];
    }
    
    
    return result;
}

+(NSString *)parseMultiSignCreateString:(NSString *)qrstr
{
    if ([qrstr rangeOfString:@"create://"].location != NSNotFound)//create://{accountname:"",creator:"",serialnumber:""}
    {
        NSMutableString *createStr = [NSMutableString stringWithString:qrstr];
        NSRange range = {0,9};
        [createStr deleteCharactersInRange:range];
        NSLog(@"create multisign string is %@",createStr);
        return  createStr;
    }
    
    return nil;
    
}

@end

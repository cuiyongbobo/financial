//
//  QRScanViewController.h
//  BitMainWallet_Hot
//
//  Created by xunianqiang on 15/1/26.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;


@property (nonatomic,copy) NSString *scanContent;//扫描地址还是私钥

@property (nonatomic,assign) NSInteger isprivkey;//1为开启私钥扫描,0为不开启，2为从相册中导入二维码
@property (nonatomic,copy) NSString *noticeString;//底部提示语

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;

@property (weak, nonatomic) IBOutlet UIButton *inputPrvkeyButton;


- (IBAction)btnClick:(id)sender;


@property (nonatomic,copy) void (^qrResult_7)(NSString *qrStr_in);//二维码扫描结果

@end

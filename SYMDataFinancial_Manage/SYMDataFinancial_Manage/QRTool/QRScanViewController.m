//
//  QRScanViewController.m
//  BitMainWallet_Hot
//
//  Created by xunianqiang on 15/1/26.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import "QRScanViewController.h"
#import "BTMQRTool.h"
#import "SYMConstantCenter.h"
//#import "KeyHandle.h"
//system
#define iOS7 ([[[UIDevice currentDevice] systemVersion]floatValue]>=7) && ([[[UIDevice currentDevice] systemVersion]floatValue]<8)
#define iOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8
#define iOS7More [[[UIDevice currentDevice] systemVersion]floatValue]>=7//ios 7以上
@interface QRScanViewController ()<ZBarReaderDelegate>

@end

@implementation QRScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//560X668 -> 280X334
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initViews];
    
    //    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    //    scanButton.frame = CGRectMake(100, 420, 120, 40);
    //    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:scanButton];
    
    //    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
    //    labIntroudction.backgroundColor = [UIColor clearColor];
    //    labIntroudction.numberOfLines=2;
    //    labIntroudction.textColor=[UIColor whiteColor];
    //    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    //    [self.view addSubview:labIntroudction];
    
    
    //    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
    //    imageView.image = [UIImage imageNamed:@"pick_bg"];
    //    [self.view addSubview:imageView];
    
    [self setupCamera];
    
    upOrdown = NO;
    num =0;
    //    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 76, 220, 2)];
    //    _line.image = [UIImage imageNamed:@"line.png"];
    //    [self.view addSubview:_line];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}


-(void)initViews
{
    [self.backButton setImage:[UIImage imageNamed:@"send_btn_go_press"] forState:UIControlStateHighlighted];
    [self.flashlightButton setImage:[UIImage imageNamed:@"send_btn_pickup_press"] forState:UIControlStateSelected];
    //    [self.inputPrvkeyButton setBackgroundImage:[UIImage imageNamed:@"public_btn03_press"]forState:UIControlStateHighlighted];
    
    if (self.isprivkey == 0) {
        [self.inputPrvkeyButton removeFromSuperview];
    }
    else if (self.isprivkey == 1)
    {
        [self.inputPrvkeyButton setTitle:NSLocalizedString(@"InputPrivkeyByHand", nil) forState:UIControlStateNormal];
    }
    else if (self.isprivkey == 2)
    {
        [self.inputPrvkeyButton setTitle:NSLocalizedString(@"ImportQRCodeFromCamera", nil) forState:UIControlStateNormal];
    }
    
    
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
    if (iOS8) {
        [self dismissViewControllerAnimated:YES completion:^{
            [timer invalidate];
        }];
    }
    else if (iOS7)
    {
        [self dismissViewControllerAnimated:NO completion:^{
            [timer invalidate];
        }];
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    [self setupCamera];//以前
}


- (void)setupCamera
{
    
    NSError *error=nil;
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    if (_input==nil || error!=nil) {
        NSLog(@"设备错误-%@",[error description]);
        UIAlertView *alterview=[[UIAlertView alloc]initWithTitle:@"" message:@"请允许照相机访问钱包" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterview show];
        return;
    }
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _preview.frame =CGRectMake(19,75,282,338);
    _preview.frame = CGRectMake(0, 0, BTMWidth, BTMHeight);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    
    [_session stopRunning];
    
    NSLog(@"qr sting  is %@",stringValue);
    if ([stringValue rangeOfString:@"create://"].location != NSNotFound) {
        //当前为创建多重签名
        
        if (iOS8) {
            [self dismissViewControllerAnimated:YES completion:^
             {
                 [timer invalidate];
                 self.qrResult_7(stringValue);
                 
             }];
        }
        else if (iOS7)
        {
            [self dismissViewControllerAnimated:NO completion:^
             {
                 [timer invalidate];
                 self.qrResult_7(stringValue);
                 
             }];
        }
        return;
    }
    
    //判断当前的地址或私钥是否正确
    NSArray *qrResult = [BTMQRTool parseQRResult:stringValue];
    //    NSLog(@"qr parse result %@",qrResult);
    NSString *aimAddr;
    NSString *aimAcount;
    if (qrResult.count == 0) {//解析错误
        
        return;
    }
    else if (qrResult.count == 1)
    {
        aimAddr = qrResult[0];
        //                aimAcount = @"0";
    }
    else if (qrResult.count == 2)
    {
        aimAddr = qrResult[0];
        aimAcount = qrResult[1];
    }
    if (self.isprivkey == 1) {
//        if (![KeyHandle checkPrivKeyValid:aimAddr]) {
//            //此处可以替换成美工的图片
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"私钥字符串无法识别" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
    }
    
//    if (![KeyHandle checkAddressValid:aimAddr] && ![KeyHandle checkPrivKeyValid:aimAddr]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"字符串无法识别" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if (iOS8) {
        [self dismissViewControllerAnimated:YES completion:^
         {
             [timer invalidate];
             //         NSLog(@"xnq   %@",stringValue);//二维码 扫描后的
             self.qrResult_7(stringValue);
             //         [[BTMUserInfo defaultUserInfo] setScanQRstr:stringValue];
             //         [[NSNotificationCenter defaultCenter]postNotificationName:@"SCANSUCESS" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:stringValue,@"QRStr", nil]];//扫描成功后给主页面发通知
         }];
    }
    else if (iOS7)
    {
        [self dismissViewControllerAnimated:NO completion:^
         {
             [timer invalidate];
             //         NSLog(@"xnq   %@",stringValue);//二维码 扫描后的
             self.qrResult_7(stringValue);
             //         [[BTMUserInfo defaultUserInfo] setScanQRstr:stringValue];
             //         [[NSNotificationCenter defaultCenter]postNotificationName:@"SCANSUCESS" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:stringValue,@"QRStr", nil]];//扫描成功后给主页面发通知
         }];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_session startRunning];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        
        if (iOS8) {
            [self dismissViewControllerAnimated:YES completion:^{
                [timer invalidate];
            }];
        }
        else if (iOS7)
        {
            [self dismissViewControllerAnimated:NO completion:^{
                [timer invalidate];
            }];
        }
    }
    else if (btn.tag == 101)
    {
        static int flag = 0;
        if (flag == 0) {
            [self turnTorchOn:YES];
            flag = 1;
            [btn setSelected:YES];
        }
        else
        {
            [self turnTorchOn:NO];
            flag = 0;
            [btn setSelected:NO];
        }
    }
    else if (btn.tag == 102)
    {
        //手动输入私钥
        if (self.isprivkey == 1) {
            if (iOS8) {
                [self dismissViewControllerAnimated:YES completion:^{
                    self.qrResult_7(@"");
                }];
            }
            else if (iOS7)
            {
                [self dismissViewControllerAnimated:NO completion:^{
                    self.qrResult_7(@"");
                }];
            }
        }
        else if (self.isprivkey == 2)//从相册中读取
        {
            ZBarReaderController *reader = [ZBarReaderController new];
            reader.allowsEditing = YES;
            reader.readerDelegate = self;
            reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:reader animated:YES completion:^{
                //                NSLog(@"跳转成功---");
            }];
        }
    }
}

- (void) turnTorchOn: (bool) on {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                //                torchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                //                torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        //        textLabel.text =  tempStr;
        NSLog(@"finally text is %@",tempStr);
        //问题：从相册扫描无法识别创建的文字？
        self.qrResult_7(tempStr);//
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    if ([info count]>2) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for(ZBarSymbol *sym in results) {
            int q = sym.quality;
            if(quality < q) {
                quality = q;
                bestResult = sym;
            }
        }
        [self performSelector: @selector(presentResult:) withObject: bestResult afterDelay: .001];
    }else {
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        [self performSelector: @selector(presentResult:) withObject: symbol afterDelay: .001];
    }
    //        [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^(void){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//}

// called when no barcode is found in an image selected by the user.
// if retry is NO, the delegate *must* dismiss the controller
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    
}



@end

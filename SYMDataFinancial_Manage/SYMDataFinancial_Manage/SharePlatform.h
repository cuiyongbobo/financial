//
//  SharePlatform.h
//  BitMainWallet_Hot
//
//  Created by cuiyong on 15/6/16.
//  Copyright (c) 2015年 xunianqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYMDataBaseModel.h"

@interface SharePlatform : NSObject
@property (nonatomic,copy) NSString *qrAddress;
@property (nonatomic,retain) UIImageView *addressImage;
@property (nonatomic,retain) NSString *backUrl;

-(void)initShare;
-(void)showShare:(id)shareViewController;
@end

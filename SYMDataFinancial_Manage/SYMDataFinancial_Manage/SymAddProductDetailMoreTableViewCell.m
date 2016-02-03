//
//  SymAddProductDetailMoreTableViewCell.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/26.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SymAddProductDetailMoreTableViewCell.h"

@interface SymAddProductDetailMoreTableViewCell ()

@end
@implementation SymAddProductDetailMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}




#pragma mark- webViewDelegate

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end

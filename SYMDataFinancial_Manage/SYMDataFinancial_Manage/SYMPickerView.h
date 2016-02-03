//
//  SYMPickerView.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYMPickerView;
@protocol SYMPickerView  <NSObject>
@optional
-(void)finallyNumber:(NSString *)number pickerView:(SYMPickerView *)pickerView;
-(void)pickerViewSelcetRow:(NSInteger)row SelectTitle:(NSString *)title pickerView:(SYMPickerView *)pickerView;
@end

@interface SYMPickerView : UIView
@property (nonatomic, assign)  id <SYMPickerView>  delegate;
@property (nonatomic, strong) NSArray *titleArray;
-(instancetype)init;
-(instancetype)initWithArray:(NSArray *)array;
@end

//
//  SYMPickerView.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/22.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMPickerView.h"

@interface SYMPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *_pickerView;
    NSMutableArray *_dataSourceArray;
    NSString *finallySelect;
    NSInteger currentRow;
}
@end
@implementation SYMPickerView



-(instancetype)init
{
    if (self = [super init]) {
        
        
        _dataSourceArray = [NSMutableArray arrayWithArray:@[@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"]];
        
        
        finallySelect = _dataSourceArray[0];
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        
        self.backgroundColor = [UIColor clearColor];
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator=YES;
        
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = self.frame;
        bgView.alpha = 0.2;
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];
        
        [self addSubview:_pickerView];
        
        UIView *headerView = [[UIView alloc]init];
        headerView.frame = CGRectMake(0, _pickerView.frame.origin.y - 32, _pickerView.frame.size.width, 31);
        [headerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:headerView];
        
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downButton.frame = CGRectMake(headerView.frame.size.width - 80, 0, 80, 30);
        [downButton setTitle:@"完成" forState:UIControlStateNormal];
        [downButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [downButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [downButton addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:downButton];
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BgViewTap:)];
        [self addGestureRecognizer:myTap];
        
    }
    return self;
}


-(instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        
        if (array != nil) {
            _dataSourceArray = [NSMutableArray arrayWithArray:array];
        }
        
        //初始化
        finallySelect = _dataSourceArray[0];
        currentRow = 0;
        
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        
        self.backgroundColor = [UIColor clearColor];
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator=YES;
        
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = self.frame;
        bgView.alpha = 0.2;
        bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgView];
        
        [self addSubview:_pickerView];
        
        UIView *headerView = [[UIView alloc]init];
        headerView.frame = CGRectMake(0, _pickerView.frame.origin.y - 32, _pickerView.frame.size.width, 31);
        [headerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:headerView];
        
        UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        downButton.frame = CGRectMake(headerView.frame.size.width - 80, 0, 80, 30);
        [downButton setTitle:@"完成" forState:UIControlStateNormal];
        [downButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [downButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [downButton addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:downButton];
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BgViewTap:)];
        [self addGestureRecognizer:myTap];
        
    }
    return self;
}

-(void)BgViewTap:(UITapGestureRecognizer *)myTap
{
    [self downClick:nil];
}

-(void)downClick:(UIButton *)btn
{
    if ( [self.delegate conformsToProtocol:@protocol(SYMPickerView)] && [self.delegate respondsToSelector:@selector(finallyNumber: pickerView:)]) {
        [self.delegate finallyNumber:finallySelect pickerView:self];
    }
    if ([self.delegate conformsToProtocol:@protocol(SYMPickerView)] && [self.delegate respondsToSelector:@selector(pickerViewSelcetRow:SelectTitle:pickerView:)]) {
        [self.delegate pickerViewSelcetRow:currentRow SelectTitle:finallySelect pickerView:self];
    }
    [_pickerView removeFromSuperview];
    [self removeFromSuperview];
    _pickerView = nil;
}



#pragma mark- PickerViewDelegate
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSourceArray.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320;
}
// 梅列高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0f;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataSourceArray[row];
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    finallySelect = _dataSourceArray[row];
    currentRow = row;
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

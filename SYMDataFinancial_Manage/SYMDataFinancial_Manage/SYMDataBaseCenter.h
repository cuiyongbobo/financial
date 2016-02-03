//
//  SYMDataBaseCenter.h
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/1.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMDataBaseCenter : NSObject

+(id)defaultDatabase;
// 插入数据
-(BOOL)addRecordWithObject:(NSObject *)oneRecord;
// 查找数据
-(NSArray *)allinformationTableRecord;
-(NSArray *)getAllinformationByUserid:(NSString *)userid;
// 更新数据
-(BOOL)updateUserinformationTablebyUserId:(NSObject *)updateData;
// 删除数据
-(BOOL)deleteRecordWithObject:(NSObject *)oneRecord;
-(BOOL)deleteRecordByUserid:(NSString *)userid;
@end

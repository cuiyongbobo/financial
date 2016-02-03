//
//  SYMDataBaseCenter.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/12/1.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMDataBaseCenter.h"
#import "FMDB.h"
#import "SYMDataBaseModel.h"

@interface SYMDataBaseCenter ()
{
    FMDatabase *_database;
}
@end
@implementation SYMDataBaseCenter

+(id)defaultDatabase
{
    static id dc = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dc = [[[self class]alloc]init];
    });
    return dc;
}

+(FMDatabaseQueue *)getSharedDatabaseQueue
{
    static FMDatabaseQueue *my_FMDatabaseQueue=nil;
    if (!my_FMDatabaseQueue) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/btmDB.sqlite"];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return my_FMDatabaseQueue;
}

-(id)init
{
    if (self = [super init]) {
        //初始化数据库
        [self initDatabase];
    }
    return self;
}

-(void)initDatabase
{
    //创建或打开数据
    //获取数据库文件的地址
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/btmDB.sqlite"];
    NSLog(@"path is  %@",path);
    _database = [[FMDatabase alloc]initWithPath:path];
    if (_database.open !=YES) {
        NSLog(@"数据库创建失败");
        return;
    }
    //数据类型
    /*
     NULL. 空值
     INTEGER. 整型
     REAL.浮点型
     TEXT.文本类型
     BLOB. 二进制类型，用来存储文件，比如图片。
     */
    //
    //表1  用户信息表
    NSString *sql = @"CREATE TABLE IF NOT EXISTS UserinformationTable"
    "(_id integer primary key autoincrement,"
    "userid TEXT,"
    "gesturespassword TEXT)";  // Gestures password
    BOOL b = [_database executeUpdate:sql];
    NSLog(@"种子表 创建成功b = %d ",b);
    [_database close];
}


-(BOOL)addRecordWithObject:(NSObject *)oneRecord
{
    __block BOOL myReturn = NO;
    FMDatabaseQueue *queue = [SYMDataBaseCenter getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([oneRecord isKindOfClass:[UserInformation class]]) {
            UserInformation *userinformation = [[UserInformation alloc]init];
            userinformation = (UserInformation *)oneRecord;
            NSString *sql = @"INSERT INTO  UserinformationTable(userid,gesturespassword) values(?,?)";
            BOOL b = [db executeUpdate:sql,userinformation.userId,userinformation.gesturespassword];
            if (b) {
                myReturn = YES;
                return ;
            }
            NSLog(@"UserinformationTable table insert success ? %d",b);
        }
    }];
    return myReturn;
}

-(NSArray *)allinformationTableRecord
{
    __block NSMutableArray *marr = [[NSMutableArray alloc]init];
    FMDatabaseQueue *queue = [SYMDataBaseCenter getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from UserinformationTable";
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            UserInformation *userinformation = [[UserInformation alloc]init];
            userinformation.userId=[set stringForColumn:@"userid"];
            userinformation.gesturespassword=[set stringForColumn:@"gesturespassword"];
            [marr addObject:userinformation];
        }
        [set close];
    }];
    return marr;
}


-(NSArray *)getAllinformationByUserid:(NSString *)userid
{
    __block NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    FMDatabaseQueue *queue = [SYMDataBaseCenter getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sqlFirst = [NSString stringWithFormat:@"select * from UserinformationTable where userid='%@'", userid];
        FMResultSet *setFirst = [db executeQuery:sqlFirst];
        while ([setFirst next]) {
            UserInformation *userinformation = [[UserInformation alloc]init];
            userinformation.userId=[setFirst stringForColumn:@"userid"];
            userinformation.gesturespassword=[setFirst stringForColumn:@"gesturespassword"];
            [resultArray addObject:userinformation];
        }
        [setFirst close];
    }];
    return resultArray;
}

-(BOOL)deleteRecordWithObject:(NSObject *)oneRecord
{
    __block BOOL myReturn = NO;
    FMDatabaseQueue *queue = [SYMDataBaseCenter getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([oneRecord isKindOfClass:[UserInformation class]]) {
            UserInformation *userinformation = [[UserInformation alloc]init];
            userinformation = (UserInformation *)oneRecord;
            NSString *sql = @"DELETE FROM UserinformationTable";
            BOOL b = [db executeUpdate:sql];
            if (b) {
                myReturn = YES;
                return ;
            }
            NSLog(@"UserInformation table delete success? %d",b);
        }
    }];
    
    return myReturn;
}

-(BOOL)deleteRecordByUserid:(NSString *)userid
{
    __block BOOL myReturn = NO;
    FMDatabaseQueue *queue = [SYMDataBaseCenter getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"DELETE FROM UserinformationTable WHERE userid = ? ";
        BOOL b = [db executeUpdate:sql,userid];
        if (b) {
            NSLog(@"UserinformationTable  delete success? %d",b);
            myReturn = YES;
            return;
        }
        NSLog(@"UserinformationTable  delete success? %d",b);
    }];
    
    return myReturn;
}


-(BOOL)updateUserinformationTablebyUserId:(NSObject *)updateData
{
#if 0
    [_database open];
    NSString *sql = [NSString stringWithFormat:@"update UserinformationTable set gesturespassword = '%@' where userid = '%@'",model.gesturespassword,model.userId];
    if ([_database executeUpdate:sql])
    {
        [_database close];
        return YES;
    }
    NSLog(@"update contact table error!");
    [_database close];
    return NO;
#endif
    
    __block BOOL myReturn = NO;
    FMDatabaseQueue *queue = [SYMDataBaseCenter getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([updateData isKindOfClass:[UserInformation class]]) {
            UserInformation *userinformation = [[UserInformation alloc]init];
            userinformation = (UserInformation *)updateData;
            NSString *sql = [NSString stringWithFormat:@"update UserinformationTable set gesturespassword = '%@' where userid = '%@'",userinformation.gesturespassword,userinformation.userId];
            BOOL b = [db executeUpdate:sql];
            if (b) {
                myReturn = YES;
                return ;
            }
            NSLog(@"UserInformation table delete success? %d",b);
        }
    }];
    
    return myReturn;
}

@end

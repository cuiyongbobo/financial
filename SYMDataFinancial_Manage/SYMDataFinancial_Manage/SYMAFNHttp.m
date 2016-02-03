//
//  SYMAFNHttp.m
//  SYMDataFinancial_Manage
//
//  Created by cuiyong on 15/11/5.
//  Copyright © 2015年 symdata. All rights reserved.
//

#import "SYMAFNHttp.h"
#import "AFNetworking.h"


@implementation SYMAFNHttp

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //[mgr.operationQueue cancelAllOperations];
    
    mgr.requestSerializer =[AFHTTPRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval =60;
    NSString *url_UTF8 = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr GET:url_UTF8 parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer =[AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    mgr.requestSerializer.timeoutInterval =60;
    
    NSString *url_UTF8 = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mgr POST:url_UTF8 parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark-提交表单
+ (void)postHttps:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    security .allowInvalidCertificates = YES;
    [mgr setSecurityPolicy:security];
    [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    mgr.requestSerializer =[AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    mgr.requestSerializer.timeoutInterval =60;
    
    NSString *url_UTF8 = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mgr POST:url_UTF8 parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - POST上传
- (void)postUpload
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:@"http://localhost/demo/upload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 将本地的文件上传至服务器
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"完成 %@", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 %@", error.localizedDescription);
    }];
}

#pragma mark- 停止网络请求
+(void)stopNetworking:(SYMAFNHttp *)ht
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.operationQueue cancelAllOperations];
    });
}

@end

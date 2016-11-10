//
//  NetWorkManager.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HttpResponse.h"

typedef NS_ENUM(NSUInteger, HttpRequestMethod) {
    HttpRequestMethodGET = 1,
    HttpRequestMethodPOST = 2
};

typedef void (^CompletionBlockWithSuccess) (NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response);

typedef void (^FailureBlock) (NSURLSessionDataTask *urlSessionDataTask, NSError *error);

typedef void (^uploadfaceBlockWithSuccess) (AFHTTPRequestOperation *operation, id responseObject);

typedef void (^uploadfaceFailureBlock) (AFHTTPRequestOperation *operation, NSError *error);
/**
 *	网络上传进度
 *	@param bytesWritten              写入的字节
 *	@param totalBytesWritten         总写入的字节
 *	@param totalBytesExpectedToWrite 要写入的总字节
 */
typedef void (^uploadProgressBlock)(long long bytesSent, long long totalBytesSent, long long totalBytesExpectedToSend);
/// 网络请求类
@interface NetWorkManager : NSObject
+ (id)shareNetWork;

- (AFHTTPRequestOperation *)requestOperation:(NSString *)requestUrl andParams:(NSDictionary *)paramDic andHeaderFieldParams:(NSDictionary *)headerFieldParamsDic andHttpRequestMethod:(HttpRequestMethod)httpRequestMethod andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;

//账号登录
-(void)LoginWithAccount:(NSString *)account andPassword:(NSString *)password andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//短信验证码登录
-(void)LoginWithPhoneNumber:(NSString *)account andVerificationCode:(NSString *)VerificationCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//接受任务
-(void)getTaskWithUserId:(NSString *)userId andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传事故基本信息
-(void)uploadBaseInfoWithTaskNo:(NSString *)taskNo andAddress:(NSString *)address andContactPerson:(NSString *)contactPerson andContactTel:(NSString *)contactTel andRemark:(NSString *)remark andAccidentDate:(NSString *)accidentDate andUserCode:(NSString *)userCode andTaskType:(NSString *)taskType andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传影像资料
-(void)uploadImageWithImgName:(NSString *)imgName andImgBase64:(NSString *)imgBase64 andReportCode:(NSString *)reportCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取城市列表
-(void)getCityListWithSearchCode:(NSString *)searchCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取医院列表
-(void)getHospitalListWithDealLocalCode:(NSString *)dealLocalCode andHospitalName:(NSString *)hospitalName andPageNo:(NSInteger)pageNo andPageSize:(NSInteger) pageSize andFlag:(NSString *)flag andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取诊断列表
-(void)getDiagnoseListWithCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
@end

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
-(void)uploadBaseInfoWithTaskNo:(NSString *)taskNo andAddress:(NSString *)address andContactPerson:(NSString *)contactPerson andContactTel:(NSString *)contactTel andRemark:(NSString *)remark andAccidentDate:(NSString *)accidentDate andUserCode:(NSString *)userCode andTaskType:(NSString *)taskType andFinishFlag:(NSString *)finishFlag andAccidentRemark:(NSString *)accidentRemark andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传影像资料
-(void)uploadImageWithImgName:(NSString *)imgName andImgBase64:(NSString *)imgBase64 andReportCode:(NSString *)reportCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取城市列表
-(void)getCityListWithSearchCode:(NSString *)searchCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取医院列表
-(void)getHospitalListWithDealLocalCode:(NSString *)dealLocalCode andHospitalName:(NSString *)hospitalName andPageNo:(NSInteger)pageNo andPageSize:(NSInteger) pageSize andFlag:(NSString *)flag andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取诊断部位列表
-(void)getDiagnoseListWithCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取诊断详细列表
-(void)getDiagnoseDeatilListWithKindCode:(NSString *)kindCode andSearchCode:(NSString *)searchCode andPageNo:(NSInteger)pageNo andPageSize:(NSInteger) pageSize andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取各类选择信息列表
-(void)getSelectListWithCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传医疗探视
-(void)uploadMedicalWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传收入情况
-(void)uploadIncomeWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传误工情况
-(void)uploadDelayWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传死亡信息
-(void)uploadDeathInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传户籍信息
-(void)uploadHouseholdInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传被抚养人信息
-(void)uploadUpBringInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//拉取伤残等级列表
-(void)getDisabilityListWithGadeCode:(NSString *)gadeCode andSearchCode:(NSString*)searchCode andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize CompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
//上传被伤残信息
-(void)uploaddDisabilityInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
@end

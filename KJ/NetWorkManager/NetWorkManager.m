//
//  NetWorkManager.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "NetWorkManager.h"
//测试地址
//#define kServerHost @"http://192.168.223.134:8088/mobileService/ifc"
//生产地址
#define kServerHost @"http://124.42.1.7:8001/mobileService/ifc"
@interface NetWorkManager ()
{
    NSString *URLPath;
}
@property (nonatomic,strong) AFHTTPSessionManager *httpSessionManager;
//  保存上一个请一个对象
@property (nonatomic,strong) NSURLSessionDataTask *previousURLSessionDataTask;

@end

static NetWorkManager *thNetWorkManager = nil;
@implementation NetWorkManager
+ (id)shareNetWork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thNetWorkManager = [[NetWorkManager alloc] init];
    });
    return thNetWorkManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thNetWorkManager = [super allocWithZone:zone];
    });
    return thNetWorkManager;
}

- (instancetype)init
{
    thNetWorkManager = [super init];
    if (thNetWorkManager) {
        
    }
    return thNetWorkManager;
}

- (id)copy
{
    return [[self class] shareNetWork];
}

- (id)mutableCopy
{
    return [[self class] shareNetWork];
}

- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        
        //返回json
        
        _httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //   配置响应序列化器的可接受内容类型acceptableContentTypes
        _httpSessionManager.responseSerializer.acceptableContentTypes = [_httpSessionManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"text/plain", @"text/html", nil]];
        //  对post方式也要编码
        //NSSet *methodEncoding = _httpSessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI;
        //methodEncoding = [methodEncoding setByAddingObject:@"POST"];
        //_httpSessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = methodEncoding;
        //  GBK请求编码和解码（顺序要在请求数据方式和返回数据方式之后，要不然编码默认是UTF-8的）
        _httpSessionManager.requestSerializer.stringEncoding = -2147482062;
        _httpSessionManager.responseSerializer.stringEncoding = -2147482062;
        _httpSessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;//  不验证ssl证书
        [_httpSessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _httpSessionManager.requestSerializer.timeoutInterval = 30.0f;
        [_httpSessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return _httpSessionManager;
}

- (void)addHeadFieldParamsDic:(NSDictionary *)headerFieldParamsDic
{
    if (headerFieldParamsDic) {
        for (NSString *key in headerFieldParamsDic.allKeys) {
            [self.httpSessionManager.requestSerializer setValue:[headerFieldParamsDic stringForKey:key] forHTTPHeaderField:key];
        }
    }
}

- (NSDictionary *)defaultHeaderField
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token == nil) {
        token = @"aaa";
    }
    return @{@"token":token,@"uuid":UUID};
}

//POST一个请求
- (void)POSTRequestOperationWithUrlPort:(NSString *)urlPort
                                 params:(NSDictionary *)params
                           successBlock:(CompletionBlockWithSuccess)successBlock
                           failureBlock:(FailureBlock)failureBlock
{
    NSString *urlPath = [thServerHost stringByAppendingString:urlPort];
    
    [self requestOperation:urlPath andParams:params andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask,HttpResponse *response){
        
        if (successBlock) {
            successBlock(urlSessionDataTask,response);
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask,NSError *error){
        if (failureBlock) {
            failureBlock(urlSessionDataTask,error);
        }
    }];
}

- (NSURLSessionDataTask *)requestOperation:(NSString *)requestUrl andParams:(NSDictionary *)paramDic andHeaderFieldParams:(NSDictionary *)headerFieldParamsDic andHttpRequestMethod:(HttpRequestMethod)httpRequestMethod andCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock) failure;
{
    
    //  添加header请求头
    if (headerFieldParamsDic) {
        [self addHeadFieldParamsDic:headerFieldParamsDic];
    }
    NSURLSessionDataTask *urlSessionDataTask = nil;
    if (httpRequestMethod == HttpRequestMethodPOST) {
        
        urlSessionDataTask = [self.httpSessionManager POST:requestUrl parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (success) {
                HttpResponse *response = [HttpResponse kyHttpResponseParse:responseObject];
                success(task,response);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(task,error);
            }
        }];
        
    } else if (httpRequestMethod == HttpRequestMethodGET) {
        
        urlSessionDataTask = [self.httpSessionManager GET:requestUrl parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if (success) {
                HttpResponse *response = [HttpResponse kyHttpResponseParse:responseObject];
                success(task,response);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(task,error);
            }
        }];
        
    }
    
    
    
    return urlSessionDataTask;
    
}

- (void)getTokenForCompletionBlockWithSuccess:(CompletionBlockWithSuccess) success andFailure:(FailureBlock)failure
{
    NSString *urlPath = [thServerHost stringByAppendingPathComponent:@"getToken.json"];
    
    NSDictionary *headDic = @{@"uuid":UUID};
    
    [self requestOperation:urlPath andParams:nil andHeaderFieldParams:headDic andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask, HttpResponse *response) {
        
        //  保存访问token?""
        NSString *token = [response.dataDic objectForKey:@"token"];
        if (token.length>0) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (success) {
            success(urlSessionDataTask,response);
        }
        
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask, NSError *error) {
        if (failure) {
            failure(urlSessionDataTask,error);
        }
    }];
}


/// 转换枚举类型对应的请求方式
- (NSString *)convertHttpPostMethodEnum:(HttpRequestMethod) httpRequestMethod
{
    if (httpRequestMethod == HttpRequestMethodGET) {
        return @"GET";
    } else if (httpRequestMethod == HttpRequestMethodPOST) {
        return @"POST";
    }
    return @"GET";
}

//GET请求方式

- (void)GETRequestOperationWithUrlPort:(NSString *)urlPort
                                params:(NSDictionary *)params
                          successBlock:(CompletionBlockWithSuccess)successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    NSString *urlPath = [thServerHost stringByAppendingString:urlPort];
    
    [self requestOperation:urlPath andParams:params andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodGET andCompletionBlockWithSuccess:^(NSURLSessionDataTask *urlSessionDataTask,HttpResponse *response){
        
        if (successBlock) {
            successBlock(urlSessionDataTask,response);
        }
    } andFailure:^(NSURLSessionDataTask *urlSessionDataTask,NSError *error){
        if (failureBlock) {
            failureBlock(urlSessionDataTask,error);
        }
    }];
}
- (NSMutableDictionary *)dataDicAndRequestCodeWithDic:(NSDictionary *)dataDic andRequestCode:(NSString *)requestCode{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    [parmDic setObject:requestCode forKey:@"requestCode"];
    [parmDic setObject:[self dictionaryToJson:dataDic] forKey:@"data"];
    return parmDic;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(void)LoginWithAccount:(NSString *)account andPassword:(NSString *)password andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic = @{@"userName":account,@"password":password};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"001001"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}

-(void)LoginWithPhoneNumber:(NSString *)account andVerificationCode:(NSString *)VerificationCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    
}
-(void)getTaskWithUserId:(NSString *)userId andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic = @{@"userId":userId};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002001"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadBaseInfoWithTaskNo:(NSString *)taskNo andAddress:(NSString *)address andContactPerson:(NSString *)contactPerson andContactTel:(NSString *)contactTel andRemark:(NSString *)remark andAccidentDate:(NSString *)accidentDate andUserCode:(NSString *)userCode andTaskType:(NSString *)taskType  andFinishFlag:(NSString *)finishFlag andAccidentRemark:(NSString *)accidentRemark andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic = @{@"taskNo":taskNo,@"address":address,@"contactPerson":contactPerson,@"contactTel":contactTel,@"remark":remark,@"accidentDate":accidentDate,@"userCode":userCode,@"finishFlag":finishFlag,@"accidentRemark":accidentRemark};
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if ([taskType isEqual:@"09"]) {
        paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002005"];
    }else if ([taskType isEqual:@"10"]){
        paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002006"];
    }
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadImageWithImgName:(NSString *)imgName andImgBase64:(NSString *)imgBase64 andReportCode:(NSString *)reportCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic = @{@"imgName":imgName,@"imgBase64":imgBase64,@"reportCode":reportCode};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002015"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)getCityListWithSearchCode:(NSString *)searchCode andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic =@{};
    if (!searchCode || [searchCode isEqual:@""]) {
    }else{
        dataDic = @{@"searchCode":searchCode};
    }
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002024"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)getHospitalListWithDealLocalCode:(NSString *)dealLocalCode andHospitalName:(NSString *)hospitalName andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize andFlag:(NSString *)flag andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    if (!dealLocalCode) {
        dealLocalCode = @"";
    }
    if (!hospitalName) {
        hospitalName = @"";
    }
    NSDictionary *dataDic = @{@"dealLocalCode":dealLocalCode,@"hospitalName":hospitalName,@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize],@"flag":flag};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002016"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)getDiagnoseListWithCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic =@{};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002029"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];

}
-(void)getDiagnoseDeatilListWithKindCode:(NSString *)kindCode andSearchCode:(NSString *)searchCode andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    if (!kindCode) {
        kindCode = @"";
    }
    if (!searchCode) {
        searchCode = @"";
    }
    NSDictionary *dataDic = @{@"kindCode":kindCode,@"searchCode":searchCode,@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize]};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002022"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)getSelectListWithCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSDictionary *dataDic =@{};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002030"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadMedicalWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002007"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadIncomeWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002008"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadDelayWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002009"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadDeathInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002011"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadHouseholdInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002010"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)uploadUpBringInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002012"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];
}
-(void)getDisabilityListWithGadeCode:(NSString *)gadeCode andSearchCode:(NSString *)searchCode andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize CompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    if (!gadeCode) {
        gadeCode = @"";
    }
    if (!searchCode) {
        searchCode = @"";
    }
    NSDictionary *dataDic = @{@"gadeCode":gadeCode,@"searchCode":searchCode,@"pageNo":[NSNumber numberWithInteger:pageNo],@"pageSize":[NSNumber numberWithInteger:pageSize]};
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dataDic andRequestCode:@"002023"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];

}
-(void)uploaddDisabilityInfoWithDataDic:(NSDictionary *)dic andCompletionBlockWithSuccess:(CompletionBlockWithSuccess)success andFailure:(FailureBlock)failure{
    NSMutableDictionary *paramDic =[self dataDicAndRequestCodeWithDic:dic andRequestCode:@"002013"];
    [self requestOperation:kServerHost andParams:paramDic andHeaderFieldParams:nil andHttpRequestMethod:HttpRequestMethodPOST andCompletionBlockWithSuccess:success andFailure:failure];

}
@end

//
//  HttpResponse.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, NetWorkType) {
    NetWorkTypeInternalHost = 1, //查询配件类型
    NetWorkTypeHost              //登录和提交类型
};
@interface HttpResponse : NSObject
/// 响应码
@property (nonatomic ,copy) NSString * responseCode;
/// 响应信息
@property (nonatomic ,copy) NSString *message;
/// 解析完成的data对应的数组数据，如果是数组 取值用这个属性
@property (nonatomic ,strong) NSArray *dataArray;
/// 解析完成的data对应的字典数据，如果是字典 取值用这个属性
@property (nonatomic ,strong) NSDictionary *dataDic;


///  解析返回成功的data数据
+ (HttpResponse *)kyHttpResponseParse:(id)data;
///  通过返回数据的字典解析model
- (id)thParseDataFromDic:(NSDictionary *)dic andModel:(Class)classModel;
@end

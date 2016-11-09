//
//  NSURLRequest+Extension.h
//  GuGuHelp
//
//  Created by JY on 15/6/4.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Extension)
///  请求接口
+ (NSURLRequest *)urlRequest:(NSString *)requestUrl andParams:(NSDictionary *)paramDic andHeaderFieldParams:(NSDictionary *)headerFieldParamsDic andHttpRequestMethod:(NSString *)httpRequestMethod;
@end

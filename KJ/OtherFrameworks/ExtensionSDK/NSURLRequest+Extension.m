//
//  NSURLRequest+Extension.m
//  GuGuHelp
//
//  Created by JY on 15/6/4.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import "NSURLRequest+Extension.h"
#import "JSONKit.h"

@implementation NSURLRequest (Extension)

+ (NSURLRequest *)urlRequest:(NSString *)requestUrl andParams:(NSDictionary *)paramDic andHeaderFieldParams:(NSDictionary *)headerFieldParamsDic andHttpRequestMethod:(NSString *)httpRequestMethod
{
    NSURL *url = [NSURL URLWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    //  请求头里面存值
    if (headerFieldParamsDic) {
        for (NSString * key in [headerFieldParamsDic allKeys])
        {
            [urlRequest addValue:[headerFieldParamsDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    //  请求体设置值
    if (paramDic) {
        //  把字典序列化成nsdata
       // NSData *data =[NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:nil];
//        NSData *data = [paramDic JSONData];
        //kNilOptions
        /*
        NSError *error;
        NSData *data = [paramDic JSONDataWithOptions:JKSerializeOptionValidFlags error:&error];
        NSLog(@"error:%@",error);
        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *paramsData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        */
        NSString *requestJsonDic = [paramDic JSONString];
        NSLog(@"请求参数:%@",requestJsonDic);
        
        NSError *error;
        NSData *data = [paramDic JSONDataWithOptions:JKSerializeOptionValidFlags error:&error];
        NSLog(@"error:%@",error);
        
        [urlRequest setHTTPBody:data];
    }
    
    [urlRequest setHTTPMethod:httpRequestMethod];
    
    
    return urlRequest;
}


@end

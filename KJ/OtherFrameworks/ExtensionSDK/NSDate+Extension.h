//
//  NSDate+Extension.h
//  AnimationDemo
//
//  Created by JY on 15/7/22.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
//  获取当前时间一周的日期数组
+ (NSMutableArray *)getWeekArray;
/**
 *  时间转还成字符串
 *
 *  @param date   时间
 *  @param format 时间格式化方式
 *
 *  @return 时间字符串
 */
+ (NSString *)stringWithDate:(NSDate*)date format:(NSString*)format;
/**
 *  字符串转换成时间
 *
 *  @param string 时间字符串
 *  @param format 时间格式化方式
 *
 *  @return 时间对象
 */
+ (NSDate *)dateWithString:(NSString*)string format:(NSString*)format;
@end

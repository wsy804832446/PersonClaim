//
//  NSDate+Extension.m
//  AnimationDemo
//
//  Created by JY on 15/7/22.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
//  根据当前时间计算周一的日期
+ (NSDate *)getFirstDayOfWeek
{
    NSDate *currentDate = [NSDate new];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit| NSMonthCalendarUnit| NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit
                               fromDate:currentDate];
    NSDate *firstDay = nil;
    if (comps.weekday == 1) {
        //周天
        firstDay = [currentDate dateByAddingTimeInterval:-6*24*3600];
    } else if (comps.weekday == 2) {
        //周一
        firstDay = [currentDate dateByAddingTimeInterval:6*24*3600];
    } else {
        //不是周一和周天，减去之间的天数
        firstDay = [currentDate dateByAddingTimeInterval:-(comps.weekday-2)*24*3600];
    }
    
    return firstDay;
}
//  获取当前时间一周的日期数组
+ (NSMutableArray *)getWeekArray
{
    NSMutableArray *weekArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSDate *firstDayOfWeek = [self getFirstDayOfWeek];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
  
    for (NSInteger i=0; i<7; i++) {
        NSDate *addDayDate = [firstDayOfWeek dateByAddingTimeInterval:i*24*3600];
        NSString *dateString = [formatter stringFromDate:addDayDate];
        [weekArray addObject:dateString];
        
    }
    return weekArray;
}
/**
 *  字符串转换成时间
 *
 *  @param string 时间字符串
 *  @param format 时间格式化方式
 *
 *  @return 时间对象
 */
+ (NSDate *)dateWithString:(NSString*)string format:(NSString*)format {
    if ([string isEqual:[NSNull null]])
        return nil;
    if (format == nil)
        format = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSDate* result = [df dateFromString:string];
    return result;
}
/**
 *  时间转还成字符串
 *
 *  @param date   时间
 *  @param format 时间格式化方式
 *
 *  @return 时间字符串
 */
+ (NSString *)stringWithDate:(NSDate*)date format:(NSString*)format {
    if ([date isEqual:[NSNull null]] || date == nil)
        return nil;
    if (format == nil)
        format = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString *dateStr = [df stringFromDate:date];
    return dateStr;
}

@end

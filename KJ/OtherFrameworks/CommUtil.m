//
//  CommUtil.m
//  LionEye
//
//  Created by JY on 15/9/15.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import "CommUtil.h"

@implementation CommUtil

+ (void)saveData:(id)dataDic andSaveFileName:(NSString *)fileName
{
    NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
    NSUserDefaults *userDefautls = [NSUserDefaults standardUserDefaults];
    [userDefautls setObject:archiverData forKey:fileName];
    [userDefautls synchronize];
}

//  读取存储数据
+ (id)readDataWithFileName:(NSString *)fileName
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *archiveData = [userDefault objectForKey:fileName];
    if (archiveData == nil) {
        return nil;
    }
    id readData = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    return readData;
}
//  删除数据
+ (void)deleteDateWithFileName:(NSString *)fileName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:fileName];
    [userDefaults synchronize];
}

//  存储到NSUserDefaults数据
+ (void)saveUserDefaultsWithObject:(id)object andUserDefaultsWithName:(NSString *)userDefaultName
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:userDefaultName];
    [userDefault synchronize];
   
}

//  删除NSUserDefaults数据
+ (void)deleteUserDefaultsDataWithUserDefaultName:(NSString *)userDefaultName
{
    [self deleteDateWithFileName:userDefaultName];
}
+ (id)readDataWithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}
@end

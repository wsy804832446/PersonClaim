//
//  CommUtil.h
//  LionEye
//
//  Created by JY on 15/9/15.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommUtil : NSObject

//  保存数据
+ (void)saveData:(id)dataDic andSaveFileName:(NSString *)fileName;
//  读取存储数据
+ (id)readDataWithFileName:(NSString *)fileName;
//  删除数据
+ (void)deleteDateWithFileName:(NSString *)fileName;

//  存储到NSUserDefaults数据
+ (void)saveUserDefaultsWithObject:(id)object andUserDefaultsWithName:(NSString *)userDefaultName;
//  删除NSUserDefaults数据
+ (void)deleteUserDefaultsDataWithUserDefaultName:(NSString *)userDefaultName;
+ (id)readDataWithKey:(NSString *)key;
@end

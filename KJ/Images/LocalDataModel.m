//
//  LocalDataModel.m
//  CHAC
//
//  Created by JY on 15/12/9.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import "LocalDataModel.h"
static LocalDataModel *localDataModel = nil;
@implementation LocalDataModel

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!localDataModel) {
            localDataModel = [[LocalDataModel alloc] init];
        }
    });
    return localDataModel;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!localDataModel) {
            localDataModel = [super allocWithZone:zone];
        }
    });
    return localDataModel;
}

- (id)copyWithZone:(NSZone *)zone
{
    return  [[self class] shareInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return  [[self class] shareInstance];
}
-(NSArray *)jobStateArray{
    if (!_jobStateArray) {
        NSMutableArray *arr = [NSMutableArray array];
        ItemTypeModel *firstModel = [[ItemTypeModel alloc]init];
        firstModel.title = @"在职";
        firstModel.value = @"0";
        ItemTypeModel *secondModel = [[ItemTypeModel alloc]init];
        secondModel.title = @"离职";
        secondModel.value = @"1";
        [arr addObject:firstModel];
        [arr addObject:secondModel];
        _jobStateArray = [NSArray arrayWithArray:arr];
    }
    return _jobStateArray;
}
-(NSArray *)labourContractArray{
    if (!_labourContractArray) {
        NSMutableArray *arr = [NSMutableArray array];
        ItemTypeModel *firstModel = [[ItemTypeModel alloc]init];
        firstModel.title = @"已签订";
        firstModel.value = @"0";
        ItemTypeModel *secondModel = [[ItemTypeModel alloc]init];
        secondModel.title = @"未签订";
        secondModel.value = @"1";
        [arr addObject:firstModel];
        [arr addObject:secondModel];
        _labourContractArray = [NSArray arrayWithArray:arr];
    }
    return _labourContractArray;
}
-(NSArray *)socialSecurityArray{
    if (!_socialSecurityArray) {
        NSMutableArray *arr = [NSMutableArray array];
        ItemTypeModel *firstModel = [[ItemTypeModel alloc]init];
        firstModel.title = @"已交";
        firstModel.value = @"0";
        ItemTypeModel *secondModel = [[ItemTypeModel alloc]init];
        secondModel.title = @"未交";
        secondModel.value = @"1";
        [arr addObject:firstModel];
        [arr addObject:secondModel];
        _socialSecurityArray = [NSArray arrayWithArray:arr];
    }
    return _socialSecurityArray;
}
-(NSArray *)getMoneyArray{
    if (!_getMoneyArray) {
        NSMutableArray *arr = [NSMutableArray array];
        ItemTypeModel *firstModel = [[ItemTypeModel alloc]init];
        firstModel.title = @"现金";
        firstModel.value = @"0";
        ItemTypeModel *secondModel = [[ItemTypeModel alloc]init];
        secondModel.title = @"转账";
        secondModel.value = @"1";
        [arr addObject:firstModel];
        [arr addObject:secondModel];
        _getMoneyArray = [NSArray arrayWithArray:arr];
    }
    return _getMoneyArray;
}
-(NSArray *)finishStateArray{
    if (!_finishStateArray) {
        NSMutableArray *arr = [NSMutableArray array];
        ItemTypeModel *firstModel = [[ItemTypeModel alloc]init];
        firstModel.title = @"已完成";
        firstModel.value = @"0";
        ItemTypeModel *secondModel = [[ItemTypeModel alloc]init];
        secondModel.title = @"未完成";
        secondModel.value = @"1";
        [arr addObject:firstModel];
        [arr addObject:secondModel];
        _finishStateArray = [NSArray arrayWithArray:arr];
    }
    return _finishStateArray;
}
@end

@implementation ItemTypeModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.value = [aDecoder decodeObjectForKey:@"value"];
    return self;
}

@end

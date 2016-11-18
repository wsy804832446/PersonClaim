//
//  LocalDataModel.h
//  CHAC
//
//  Created by JY on 15/12/9.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDataModel : NSObject <NSCopying,NSMutableCopying>

+ (instancetype)shareInstance;
//在职情况
@property (nonatomic,strong)NSArray *jobStateArray;
//劳动合同
@property (nonatomic,strong)NSArray *labourContractArray;
//社保
@property (nonatomic,strong)NSArray *socialSecurityArray;
//收入发放形式
@property (nonatomic,strong)NSArray *getMoneyArray;
//完成状态
@property (nonatomic,strong)NSArray *finishStateArray;
@end


@interface ItemTypeModel : NSObject<NSCoding>

//  数据标题
@property (nonatomic, copy) NSString *title;
//  数据标题对应的值
@property (nonatomic, copy) NSString *value;

@end

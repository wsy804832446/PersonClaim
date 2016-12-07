//
//  ClaimModel.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/2.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "ClaimModel.h"

@implementation ClaimModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}
-(NSMutableArray *)taskArr{
    if (!_taskArr) {
        _taskArr = [NSMutableArray array];
    }
    return _taskArr;
}
@end


@implementation TaskModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}
@end

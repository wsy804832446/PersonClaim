//
//  CityModel.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"Id":@"aid"};
}
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end

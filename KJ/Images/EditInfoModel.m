//
//  EditInfoModel.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/2.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "EditInfoModel.h"

@implementation EditInfoModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{};
}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)hosArray{
    if (!_hosArray) {
        _hosArray = [NSMutableArray array];
    }
    return _hosArray;
}
-(NSMutableArray *)diaArray{
    if (!_diaArray) {
        _diaArray = [NSMutableArray array];
    }
    return _diaArray;
}
-(NSMutableArray *)carePeopleArray{
    if (!_carePeopleArray) {
        _carePeopleArray = [NSMutableArray array];
    }
    return _carePeopleArray;
}

@end

@implementation imageModel


@end

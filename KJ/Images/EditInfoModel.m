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
@end

@implementation imageModel


@end

//
//  HospitalModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/10.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface HospitalModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *hospitalProperty;

@property (nonatomic,copy) NSString *hospitalTel;

@property (nonatomic,copy) NSString *hospitalAddress;

@property (nonatomic,copy) NSString *hospitalName;

@property (nonatomic,copy) NSString *hospitalTypeCode;

@property (nonatomic,copy) NSString *hospitalCode;

@property (nonatomic,copy) NSString *hospitalId;

@property (nonatomic,copy) NSString *hospitalLevel;
@end

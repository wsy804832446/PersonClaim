//
//  DisabilityModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/23.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface DisabilityModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *disabilityGradeId;

@property (nonatomic,copy)NSString *disabilityCode;

@property (nonatomic,copy)NSString *disabilityDescr;

@property (nonatomic,copy)NSString *disabilityScale;
@end

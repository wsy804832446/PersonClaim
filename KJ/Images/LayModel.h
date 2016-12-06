//
//  LayModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/12/6.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface LayModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *lawId;

@property (nonatomic,copy)NSString *lawShortName;

@property (nonatomic,copy)NSString *lawOrder;

@property (nonatomic,copy)NSString *lawFullName;

@property (nonatomic,copy)NSString *lawFullContent;

@property (nonatomic,copy)NSString *createUserId;

@property (nonatomic,copy)NSString *createDate;
@end

//
//  SelectList.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface SelectList : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *key;

@property (nonatomic,copy)NSString *typeCode;

@property (nonatomic,copy)NSString *value;
@end

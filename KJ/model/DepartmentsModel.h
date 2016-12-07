//
//  DepartmentsModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface DepartmentsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *key;

@property (nonatomic,copy)NSString *value;

@property (nonatomic,assign)BOOL isSelected;
@end

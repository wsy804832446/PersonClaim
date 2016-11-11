//
//  DiagnoseDetailModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface DiagnoseDetailModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *Id;

@property (nonatomic,copy)NSString *itemCode;

@property (nonatomic,copy)NSString *itemCnName;
@end

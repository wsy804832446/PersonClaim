//
//  BodyPartModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/10.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface BodyPartModel : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *Id;

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *name;
@end

//
//  CarePeopleModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"
#import "SelectList.h"
@interface CarePeopleModel : MTLModel
@property (nonatomic,strong)SelectList *identity;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *days;

@property (nonatomic,copy)NSString *cost;
@end

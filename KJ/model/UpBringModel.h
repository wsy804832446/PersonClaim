//
//  UpBringModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/22.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"
#import "SelectList.h"
@interface UpBringModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *birthday;

@property(nonatomic,strong)SelectList *householdType;

@property(nonatomic,strong)SelectList *Relation;

@property(nonatomic,copy)NSString *age;

@property(nonatomic,copy)NSString *years;

@property(nonatomic,copy)NSString *upBringNum;

@property(nonatomic,copy)NSString *address;

@property (nonatomic,assign)BOOL selected;
@end

//
//  ContactPeopleModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/2.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"
#import "SelectList.h"
@interface ContactPeopleModel : MTLModel
@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *phone;
//身份（被询问人）
@property (nonatomic,strong)SelectList *insiderIdentity;
@end

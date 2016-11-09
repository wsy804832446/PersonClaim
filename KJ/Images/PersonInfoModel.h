//
//  PersonInfoModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/10/27.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface PersonInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString*Id;

@property (nonatomic,copy)NSString*userName;

@property (nonatomic,copy)NSString*personName;

@property (nonatomic,copy)NSString*userCode;

@property (nonatomic,copy)NSString*userPassword;

@property (nonatomic,copy)NSString*userSex;

@property (nonatomic,copy)NSString*userOrgId;

@property (nonatomic,copy)NSString*userOrgCode;

@property (nonatomic,copy)NSString*userOrgName;

@property (nonatomic,copy)NSString*isAdminFlag;

@property (nonatomic,copy)NSString*stopFlag;

@property (nonatomic,copy)NSString*expirationDate;

@property (nonatomic,copy)NSString*delFlag;

@property (nonatomic,copy)NSString*createId;

@property (nonatomic,copy)NSString*createDate;

@property (nonatomic,copy)NSString*updateId;

@property (nonatomic,copy)NSString*updateDate;
@end

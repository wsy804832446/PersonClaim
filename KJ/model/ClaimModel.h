//
//  ClaimModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/2.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface ClaimModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *claimId;

@property (nonatomic,copy)NSString *reportNo;

@property (nonatomic,copy)NSString *reportDate;

@property (nonatomic,copy)NSString *insuredName;

@property (nonatomic,copy)NSString *plateNo;

@property (nonatomic,copy)NSString *dangerDate;

@property (nonatomic,copy)NSString *mobilePhone;

@property (nonatomic,copy)NSString *companyId;

@property (nonatomic,copy)NSString *companyName;

@property (nonatomic,copy)NSString *bPolicyNo;

@property (nonatomic,copy)NSString *fPolicyNo;

@property (nonatomic,copy)NSString *createDate;

@property (nonatomic,copy)NSString *lockFlag;

@property (nonatomic,strong)NSMutableArray *taskList;
//分类时用到
@property (nonatomic,strong)NSMutableArray *taskArr;
@end



@interface TaskModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy)NSString *taskNo;

@property (nonatomic,copy)NSString *claimId;

@property (nonatomic,copy)NSString *taskType;

@property (nonatomic,copy)NSString *taskState;

@property (nonatomic,copy)NSString *taskName;

@property (nonatomic,copy)NSString *injureName;

@property (nonatomic,copy)NSString *injureId;

@property (nonatomic,copy)NSString *dispatchDate;

@property (nonatomic,copy)NSString *deadline;
@end

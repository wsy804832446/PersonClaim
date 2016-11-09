//
//  EditInfoModel.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/2.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MTLModel.h"

@interface EditInfoModel : MTLModel<MTLJSONSerializing>
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *contactPerson;
@property(nonatomic,copy)NSString *contactTel;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *accidentDate;
@property(nonatomic,copy)NSString *userCode;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end

@interface imageModel : MTLModel
@property (nonatomic,copy)NSString *imgName;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)NSString *imgBase64;
@property (nonatomic,assign)BOOL isUpload;
@end

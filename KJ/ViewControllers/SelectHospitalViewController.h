//
//  SelectHospitalViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CityModel.h"
#import "HospitalModel.h"
@interface SelectHospitalViewController : BaseTableViewController
@property (nonatomic,copy)void (^selectBlock)(HospitalModel *model,NSMutableArray *array);
//已选城市
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)void (^selectOrganizationBlock)(HospitalModel *model);
//为1是医院  为2是鉴定机构
@property (nonatomic,copy)NSString *flag;
@end

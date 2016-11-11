//
//  SelectDepartmentViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "HospitalModel.h"
@interface SelectDepartmentViewController : BaseTableViewController
//上页传过来医院model
@property (nonatomic,strong)HospitalModel *hospitalModel;
//选择后回调block  医院model 和装有诊断model的数组
@property (nonatomic,copy)void (^selectBlock)(HospitalModel *model,NSMutableArray *array);
@end

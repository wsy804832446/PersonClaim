//
//  AddCarePeopleViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CarePeopleModel.h"
@interface AddCarePeopleViewController : BaseTableViewController
//添加护理人回调
@property(nonatomic,copy)void(^addCareBlock)(NSMutableArray *array);
@end

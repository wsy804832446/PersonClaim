//
//  SelectDefiniteCityViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CityModel.h"
@interface SelectDefiniteCityViewController : BaseTableViewController
@property (nonatomic,copy)void (^SelectCityBlock)(NSString *cityId);
//拉取城市到几级 1省  2市  3县
@property (nonatomic,assign)NSInteger cityLevel;
@end

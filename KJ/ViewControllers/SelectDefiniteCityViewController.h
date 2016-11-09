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
@property (nonatomic,copy)void (^SelectCityBlock)(CityModel *cityModel);
@end

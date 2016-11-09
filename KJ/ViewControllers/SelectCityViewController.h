//
//  SelectCityViewController.h
//  KJ
//
//  Created by 王晟宇 on 16/10/9.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CityModel.h"
@interface SelectCityViewController : BaseTableViewController
@property (nonatomic,copy)void (^SelectCityBlock)(NSString *city);
//已选城市
@property (nonatomic,copy)NSString *city;

@end

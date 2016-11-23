//
//  SelectDisabilityTypeViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/23.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
@interface SelectDisabilityTypeViewController : BaseTableViewController
@property (nonatomic,copy)void(^selectBlock)(NSMutableArray *array);
@end

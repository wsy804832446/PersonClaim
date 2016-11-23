//
//  AddUpBringViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/22.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UpBringModel.h"
@interface AddUpBringViewController : BaseTableViewController
//添加被抚养人回调
@property(nonatomic,copy)void(^addUpBringBlock)(NSMutableArray *array);
@end

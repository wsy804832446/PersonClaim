//
//  DelayViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/20.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ClaimModel.h"
@interface DelayViewController : BaseTableViewController
@property (nonatomic,strong)ClaimModel *claimModel;
@property (nonatomic,strong)TaskModel *taskModel;
@end

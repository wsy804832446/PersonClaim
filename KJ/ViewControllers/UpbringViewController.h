//
//  UpbringViewController.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/22.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ClaimModel.h"
@interface UpbringViewController : BaseTableViewController
@property (nonatomic,strong)ClaimModel *claimModel;
@property (nonatomic,strong)TaskModel *taskModel;
//保存信息block
@property (nonatomic,copy)void (^saveInfoBlock)(EditInfoModel *model);
@end

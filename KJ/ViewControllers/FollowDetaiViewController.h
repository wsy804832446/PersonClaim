//
//  FollowDetaiViewController.h
//  KJ
//
//  Created by 王晟宇 on 16/10/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ClaimModel.h"
typedef NS_ENUM(NSInteger ,FollowState){
    //完成
    complete = 0,
    //待办
    stay = 1,
    //进行中
    underway = 2,
    //超时
    overTime = 3
};
@interface FollowDetaiViewController : BaseTableViewController
@property (nonatomic,assign)FollowState state;
@property (nonatomic,strong)ClaimModel *claimModel;
@property (nonatomic,strong)TaskModel *taskModel;
@end

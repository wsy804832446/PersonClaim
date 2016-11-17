//
//  FollowPlatFormViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/10/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowPlatFormViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *line;
//姓名
@property (strong, nonatomic) IBOutlet UILabel *lblName;
//报案号
@property (strong, nonatomic) IBOutlet UILabel *lblNum;
//时间
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
//超出时间
@property (strong, nonatomic) IBOutlet UILabel *lblOverTime;
//完成状态
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UILabel *lblTaskType;

@end

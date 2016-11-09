//
//  FollowDetailTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/10/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClaimModel.h"
@interface FollowDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
//完成状态
@property (strong, nonatomic) IBOutlet UIImageView *imgState;
//拨号按钮
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
//报案号
@property (strong, nonatomic) IBOutlet UILabel *lblNum;
//时间
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (nonatomic,copy) void(^callBlock)();
- (IBAction)actionCall:(id)sender;
-(void)configCellWithModel:(ClaimModel *)claimModel;
@end

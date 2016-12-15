//
//  LXRTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/12/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXRTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *line;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (nonatomic,copy) void(^btnCallClickBlock)();
@end

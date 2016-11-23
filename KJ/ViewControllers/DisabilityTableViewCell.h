//
//  DisabilityTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/23.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisabilityModel.h"
@interface DisabilityTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UIView *line;
-(void)configCellWithModel:(DisabilityModel *)model;
@end

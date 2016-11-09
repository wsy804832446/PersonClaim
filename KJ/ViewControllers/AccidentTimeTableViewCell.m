//
//  AccidentTimeTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/1.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AccidentTimeTableViewCell.h"

@implementation AccidentTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    UIImage *img =[UIImage imageNamed:@"箭头"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.btnTime2 setImage:img forState:UIControlStateNormal];
    [self.btnTime2 setImageEdgeInsets:UIEdgeInsetsMake(13, 0, 13, 0)];
    [self.btnTime setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
    [self.btnTime setTitle:@"必选" forState:UIControlStateNormal];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

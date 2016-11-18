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
    [self.btnTime setImage:img forState:UIControlStateNormal];
    [self.btnTime setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
    [self.btnTime setTitle:@"必选" forState:UIControlStateNormal];
    [self.btnTime setImageEdgeInsets:UIEdgeInsetsMake(14, 200-10, 14, 0)];
    [self.btnTime setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    self.lblLine.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

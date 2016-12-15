//
//  LXRTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/12/11.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "LXRTableViewCell.h"

@implementation LXRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnCall setImage:[UIImage imageNamed:@"10"] forState:UIControlStateNormal];
    [self.btnCall setImage:[UIImage imageNamed:@"10-1"] forState:UIControlStateHighlighted];
    [self.btnCall setImageEdgeInsets:UIEdgeInsetsMake(11, 10, 11, 15)];
    self.lblPhoneNumber.textColor = [UIColor colorWithHexString:Colorgray];
    [self.btnCall addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    // Initialization code
}
-(void)btnClick{
    if (self.btnCallClickBlock) {
        self.btnCallClickBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

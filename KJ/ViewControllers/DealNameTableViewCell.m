//
//  DealNameTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/7.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "DealNameTableViewCell.h"

@implementation DealNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.txtName setValue:[UIColor colorWithHexString:@"#bbbbbb"] forKeyPath:@"_placeholderLabel.textColor"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  DefaultCellTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/18.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "DefaultCellTableViewCell.h"

@implementation DefaultCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

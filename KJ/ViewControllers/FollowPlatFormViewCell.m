//
//  FollowPlatFormViewCell.m
//  KJ
//
//  Created by 王晟宇 on 16/10/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FollowPlatFormViewCell.h"

@implementation FollowPlatFormViewCell

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

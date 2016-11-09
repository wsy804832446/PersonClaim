//
//  FollowEditTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 16/10/19.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FollowEditTableViewCell.h"

@implementation FollowEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
//    label.frame = CGRectMake(0, 0, label.text.length*16, <#CGFloat height#>)
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

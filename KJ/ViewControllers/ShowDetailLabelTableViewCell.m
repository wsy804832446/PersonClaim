//
//  ShowDetailLabelTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/12/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "ShowDetailLabelTableViewCell.h"

@implementation ShowDetailLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblShowDetail.numberOfLines =0;
    self.line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    self.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    self.lblTitle.backgroundColor = [UIColor colorWithHexString:Colorwhite];
    // Initialization code
}
-(void)configCellWithString:(NSString *)string{
    self.lblShowDetail.text = string;
    CGSize maximumLabelSize = CGSizeMake(100, 9999);
    CGSize expectSize = [self.lblShowDetail sizeThatFits:maximumLabelSize];
    self.lblShowDetail.frame = CGRectMake(self.lblShowDetail.origin.x, self.lblShowDetail.origin.y, expectSize.width, expectSize.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  DisabilityTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/23.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "DisabilityTableViewCell.h"

@implementation DisabilityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage *img1 = [UIImage imageNamed:@"切图-跟踪_r2_c1"];
    img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2 = [UIImage imageNamed:@"切图-跟踪_r1_c3"];
    img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.btnSelect setImage:img1 forState:UIControlStateNormal];
    [self.btnSelect setImage:img2 forState:UIControlStateSelected];
    [self.btnSelect setImageEdgeInsets:UIEdgeInsetsMake(16, 0, 0, 0)];
    self.lblText.numberOfLines =0;
    self.line.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    // Initialization code
}
-(void)configCellWithModel:(DisabilityModel *)model{
    NSString *str = [NSString stringWithFormat:@"[%@]  ",model.disabilityCode];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorblue]}];
    [attStr appendAttributedString:[[NSMutableAttributedString alloc]initWithString:model.disabilityDescr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:Colorblack]}]];
    self.lblText.attributedText = attStr;
    self.lblText.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize maximumLabelSize = CGSizeMake(self.lblText.width, 9999);//labelsize的最大值
    CGSize expectSize = [self.lblText sizeThatFits:maximumLabelSize];
    self.lblText.frame =CGRectMake(self.btnSelect.right+10 , 15, expectSize.width, expectSize.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

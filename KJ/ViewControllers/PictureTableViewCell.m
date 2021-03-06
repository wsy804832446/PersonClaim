//
//  PictureTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/3.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "PictureTableViewCell.h"

@implementation PictureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSAttributedString *identity = [[NSAttributedString alloc]initWithString:@"(必填)"attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:placeHoldColor]}];
    NSAttributedString *strName = [[NSAttributedString alloc]initWithString:@"影像资料" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]}];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:strName];
    [string appendAttributedString:identity];
    self.lblTitle.attributedText = string;
    self.lblLine.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    // Initialization code
}
-(void)configImgWithImgArray:(NSMutableArray *)array{
    for (int i=0; i<=array.count; i++) {
        UIButton *btnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImg.backgroundColor = [UIColor colorWithHexString:Colorwhite];
        CGFloat width = (DeviceSize.width-15)/4;
        btnImg.frame = CGRectMake(15+width*(i%4), self.lblTitle.bottom+12+i/4*87, 75, 75);
        [btnImg setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        if (i<array.count) {
            [btnImg setBackgroundImage:array[i] forState:UIControlStateNormal];
        }else{
            [btnImg setBackgroundImage:[UIImage imageNamed:@"13-1"] forState:UIControlStateNormal];
        }
        [btnImg addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btnImg.tag = 2000+i;
        [self addSubview:btnImg];
        self.constrainBottom.constant = btnImg.bottom;
    }
}
-(void)click:(UIButton *)btn{
    if (self.btnSelectBlock) {
        self.btnSelectBlock(btn);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

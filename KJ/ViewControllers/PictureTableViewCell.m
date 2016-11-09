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
    self.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    // Initialization code
}
-(void)configImgWithImgArray:(NSMutableArray *)array{
    for (int i=0; i<=array.count; i++) {
        UIButton *btnImg = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (DeviceSize.width-15)/4;
        btnImg.frame = CGRectMake(15+width*(i%4), self.lblTitle.bottom+12+i/4*87, 75, 75);
        if (i<array.count) {
             [btnImg setImage:array[i] forState:UIControlStateNormal];
        }else{
             [btnImg setImage:[UIImage imageNamed:@"13-1"] forState:UIControlStateNormal];
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

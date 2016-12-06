//
//  FollowDetailTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 16/10/17.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "FollowDetailTableViewCell.h"

@implementation FollowDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:Colorblue];
    self.lblType.backgroundColor = [UIColor colorWithHexString:Colorwhite alpha:0.26];
    self.lblType.textColor = [UIColor colorWithHexString:Colorwhite];
    self.lblType.layer.masksToBounds = YES;
    self.lblType.layer.cornerRadius = 30;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionCall:(id)sender {
    if (self.callBlock) {
        self.callBlock();
    }
}

-(void)configCellWithModel:(ClaimModel *)claimModel{
    self.lblName.text = claimModel.insuredName;
    self.lblName.textColor = [UIColor colorWithHexString:Colorwhite];
    self.lblTime.textColor = [UIColor colorWithHexString:Colorwhite alpha:0.82];
    [self.btnCall setImage:[[UIImage imageNamed:@"nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    [self.btnCall setImage:[[UIImage imageNamed:@"pre"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateHighlighted];
    [self.btnCall setImageEdgeInsets:UIEdgeInsetsMake(40, 53/2, 40, 53/2)];
//    self.state = 1;
    //state图片18-21
//    switch (self.state) {
//        case 0:
//            self.imgState.image = [UIImage imageNamed:@"20"];
//        case 1:
            self.imgState.image = [UIImage imageNamed:@"finish"];
//    break;
//        case 2:
//            cell.imgState.image = [UIImage imageNamed:@"21"];break;
//        case 3:
//            cell.imgState.image = [UIImage imageNamed:@"19"];break;
//        default:
//            break;
//    }

}
@end

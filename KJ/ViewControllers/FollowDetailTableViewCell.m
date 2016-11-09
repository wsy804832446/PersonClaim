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
    self.lblNum.text = [NSString stringWithFormat:@"报案号:%@",claimModel.reportNo];
    self.lblNum.textColor = [UIColor colorWithHexString:Colorgray];
    self.lblTime.textColor = [UIColor colorWithHexString:Colorgray];
    [self.btnCall setImage:[UIImage imageNamed:@"10"] forState:UIControlStateNormal];
    [self.btnCall setImage:[UIImage imageNamed:@"10-1"] forState:UIControlStateHighlighted];
//    self.state = 1;
    //state图片18-21
//    switch (self.state) {
//        case 0:
            self.imgState.image = [UIImage imageNamed:@"20"];
//        case 1:
//            cell.imgState.image = [UIImage imageNamed:@"18"];break;
//        case 2:
//            cell.imgState.image = [UIImage imageNamed:@"21"];break;
//        case 3:
//            cell.imgState.image = [UIImage imageNamed:@"19"];break;
//        default:
//            break;
//    }

}
@end

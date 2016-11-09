//
//  MedicalVisitTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MedicalVisitTableViewCell.h"

@implementation MedicalVisitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblTitle.textColor = [UIColor colorWithHexString:Colorblack];
    self.lblDetail.textColor = [UIColor colorWithHexString:Colorgray];
    self.lblMoney.textColor = [UIColor colorWithHexString:Colorgray];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  AccidentAddressTableViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/1.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "AccidentAddressTableViewCell.h"
@implementation AccidentAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblTitle.text = @"事故地址";
    self.lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    self.lblPlaceHolder.textColor = [UIColor colorWithHexString:placeHoldColor];
    self.txtDetail.textColor = [UIColor colorWithHexString:Colorblack];
    self.txtDetail.contentInset = UIEdgeInsetsMake(0, -5, 0, -5);
    [self.btnMap setImage:[UIImage imageNamed:@"32"] forState:UIControlStateNormal];
    [self.btnMap setImageEdgeInsets:UIEdgeInsetsMake(11, 16, 0, 0)];
    // Initialization code
}
- (IBAction)actionMap:(id)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}
-(void)configCellWithAddress:(NSString *)address{
    self.txtDetail.text = address;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

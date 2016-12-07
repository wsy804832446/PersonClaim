//
//  HomeShaiXuanCollectionViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/12/7.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "HomeShaiXuanCollectionViewCell.h"

@implementation HomeShaiXuanCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnType.enabled = NO;
    // Initialization code
}
-(void)configCellWithRow:(NSInteger)row{
    switch (row) {
        case 0:
            self.lblText.text = @"全部任务";
            [self.btnType setImage:[[UIImage imageNamed:@"0_all_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 1:
            self.lblText.text = @"伤者基本信息";
            [self.btnType setImage:[[UIImage imageNamed:@"1_basic_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 2:
            self.lblText.text = @"事故现场";
            [self.btnType setImage:[[UIImage imageNamed:@"2_process_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 3:
            self.lblText.text = @"医院探视";
            [self.btnType setImage:[[UIImage imageNamed:@"3_hospital_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 4:
            self.lblText.text = @"收入情况";
            [self.btnType setImage:[[UIImage imageNamed:@"4_salary_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 5:
            self.lblText.text = @"误工情况";
            [self.btnType setImage:[[UIImage imageNamed:@"5_work_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 6:
            self.lblText.text = @"户籍居住";
            [self.btnType setImage:[[UIImage imageNamed:@"6_houseregister_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 7:
            self.lblText.text = @"被扶养人";
            [self.btnType setImage:[[UIImage imageNamed:@"7_raised_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 8:
            self.lblText.text = @"伤残鉴定";
            [self.btnType setImage:[[UIImage imageNamed:@"8_disability_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        case 9:
            self.lblText.text = @"死亡信息";
            [self.btnType setImage:[[UIImage imageNamed:@"9_death_mormal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [self.btnType setImageEdgeInsets:UIEdgeInsetsMake(15,(self.width-55)/2, 34, (self.width-55)/2)];
            break;
        default:
            break;
    }

}
@end

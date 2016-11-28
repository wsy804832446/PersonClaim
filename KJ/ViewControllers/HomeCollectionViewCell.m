//
//  HomeCollectionViewCell.m
//  KJ
//
//  Created by 王晟宇 on 2016/11/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lblText.textColor = [UIColor colorWithHexString:@"#999999"];
    self.lblText.font = [UIFont systemFontOfSize:12];
    // Initialization code
}
-(void)configCellWithRow:(NSInteger)row{
    switch (row) {
        case 0:
            self.lblText.text = @"伤者基本信息";
            self.imgView.image = [UIImage imageNamed:@"1_basic"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            break;
        case 1:
            self.lblText.text = @"事故现场";
            self.imgView.image = [UIImage imageNamed:@"2_process"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            break;
        case 2:
            self.lblText.text = @"医院探视";
            self.imgView.image = [UIImage imageNamed:@"3_hospital"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            break;
        case 3:
            self.lblText.text = @"收入情况";
            self.imgView.image = [UIImage imageNamed:@"4_salary"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            break;
        case 4:
            self.lblText.text = @"误工情况";
            self.imgView.image = [UIImage imageNamed:@"5_work"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            break;
        case 5:
            self.lblText.text = @"户籍居住";
            self.imgView.image = [UIImage imageNamed:@"6_houseregister"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            break;
        case 6:
            self.lblText.text = @"被扶养人";
            self.imgView.image = [UIImage imageNamed:@"1_basic"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            break;
        case 7:
            self.lblText.text = @"伤残鉴定";
            self.imgView.image = [UIImage imageNamed:@"8_disability"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            break;
        case 8:
            self.lblText.text = @"死亡信息";
            self.imgView.image = [UIImage imageNamed:@"9_death"];
            self.lineRight.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            self.lineBottom.backgroundColor = [UIColor colorWithHexString:Colorwhite];
            break;
        default:
            break;
    }
}
@end

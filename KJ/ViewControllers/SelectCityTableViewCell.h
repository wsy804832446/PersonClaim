//
//  SelectCityTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/10/10.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
//选中对勾
@property (copy, nonatomic) NSString *cityId;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end

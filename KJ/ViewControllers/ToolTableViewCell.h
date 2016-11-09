//
//  ToolTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/9/30.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *Detail;
@property (strong, nonatomic) IBOutlet UILabel *kind;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *city;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelConstrains;

@end

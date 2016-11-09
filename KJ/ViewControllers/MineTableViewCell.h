//
//  MineTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/9/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UIImageView *imgLeft;
@property (strong, nonatomic) IBOutlet UIImageView *imgRight;

@end

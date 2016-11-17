//
//  DealNameTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/7.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealNameTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *lblLine;

@end

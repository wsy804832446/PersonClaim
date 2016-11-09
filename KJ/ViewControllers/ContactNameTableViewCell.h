//
//  ContactNameTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 16/10/20.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactNameTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIView *lineH;

@property (strong, nonatomic) IBOutlet UIView *lineV;
@end

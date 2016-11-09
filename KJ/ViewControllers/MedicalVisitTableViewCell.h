//
//  MedicalVisitTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalVisitTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblMoney;

@end

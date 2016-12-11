//
//  ShowDetailLabelTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/12/8.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailLabelTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblShowDetail;
@property (strong, nonatomic) IBOutlet UIView *line;

-(void)configCellWithString:(NSString *)string;
@end

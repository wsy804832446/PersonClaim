//
//  MineTableViewCell2.h
//  KJ
//
//  Created by 王晟宇 on 16/9/27.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MineTableViewCell2 : BaseTableViewCell
//cell文本内容

@property (strong, nonatomic) IBOutlet UILabel *labelLeft;

//cell前图标
@property (strong, nonatomic) IBOutlet UIImageView *imgLeft;

//cell副文本内容
@property (strong, nonatomic) IBOutlet UILabel *labelRight;

//箭头
@property (strong, nonatomic) IBOutlet UIImageView *imgRight;


@end

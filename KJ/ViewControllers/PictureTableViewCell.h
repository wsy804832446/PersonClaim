//
//  PictureTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/3.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constrainBottom;
@property (nonatomic,copy)void(^btnSelectBlock)(UIButton *btn);
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
-(void)configImgWithImgArray:(NSMutableArray *)array;

@end

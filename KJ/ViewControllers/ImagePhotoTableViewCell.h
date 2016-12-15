//
//  ImagePhotoTableViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/12/12.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePhotoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *line;
@property (nonatomic,copy)void(^btnSelectBlock)(UIButton *btn);
-(void)configImgWithImgArray:(NSMutableArray *)array;
@end

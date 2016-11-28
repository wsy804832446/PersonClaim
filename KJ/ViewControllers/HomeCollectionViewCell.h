//
//  HomeCollectionViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/11/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *lineBottom;
@property (strong, nonatomic) IBOutlet UIView *lineRight;

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblText;
-(void)configCellWithRow:(NSInteger)row;
@end

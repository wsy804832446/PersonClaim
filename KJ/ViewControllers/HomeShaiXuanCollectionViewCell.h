//
//  HomeShaiXuanCollectionViewCell.h
//  KJ
//
//  Created by 王晟宇 on 2016/12/7.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeShaiXuanCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgType;

@property (strong, nonatomic) IBOutlet UILabel *lblText;
-(void)configCellWithRow:(NSInteger)row;
@end

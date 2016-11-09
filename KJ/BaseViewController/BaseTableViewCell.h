//
//  BaseTableViewCell.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
/**
 *  父类。。。子类继承后直接调用函数入口
 */
- (void)customView;
@end

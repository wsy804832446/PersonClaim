//
//  BaseViewController.h
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItemExtension.h"

@interface BaseViewController : UIViewController
/// 距离屏幕顶部的距离
@property(nonatomic,readonly) CGFloat viewTop;
/// 距离屏幕顶部的高度
@property(nonatomic,readonly) CGFloat frameTopHeight;
@end

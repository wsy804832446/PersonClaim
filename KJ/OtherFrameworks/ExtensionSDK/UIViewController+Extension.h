//
//  UIViewController+Extension.h
//  Claim
//
//  Created by JY on 15/4/29.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (Extension)

/// 弹框提示
- (void)alertView:(NSString *)message;

/// 回调的方法
- (void)alertView:(NSString *)message andTitle:(NSString *)title andCancelButtonTitle:(NSString *)cancelTitle andOkButtonTitle:(NSString *)okTitle andTarget:(id)target andAlertActionBlock:(void (^) (NSInteger index)) alertActionBlock;

/// 手动关闭的提示框
- (void)removeMBProgressHudInManaual;

/// 等待视图
- (MBProgressHUD *)showHudWaitingView:(NSString *)prompt;

/// 提示警告信息自动关闭
- (MBProgressHUD *)showHudAuto:(NSString *)text;
//提示警告信息自动关闭
- (MBProgressHUD *)showHudAuto:(NSString *)text andDuration:(NSString *)duration;
///  弹框提示
- (void)alertView:(NSString *)message andtitle:(NSString *)title;
@end

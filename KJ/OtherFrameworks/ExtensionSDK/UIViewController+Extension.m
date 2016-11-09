//
//  UIViewController+Extension.m
//  Claim
//
//  Created by guohaibin on 15/4/29.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

///  弹框提示
- (void)alertView:(NSString *)message
{
    UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

/// 回调的方法
- (void)alertView:(NSString *)message andTitle:(NSString *)title andCancelButtonTitle:(NSString *)cancelTitle andOkButtonTitle:(NSString *)okTitle andTarget:(id)target andAlertActionBlock:(void (^) (NSInteger index)) alertActionBlock
{
    UIAlertController * alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action=[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction * action2=[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (alertActionBlock) {
            alertActionBlock(2);
        }
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

//  获取顶部的视图
- (UIWindow *)promptingTopView
{
    UIWindow *currentWindow = nil;
    
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            currentWindow = window;
            break;
        }
    }
    return currentWindow;
}



//  手动关闭的提示框
- (void)removeMBProgressHudInManaual
{
    [MBProgressHUD hideAllHUDsForView:[self promptingTopView] animated:YES];
}
//  等待视图
- (MBProgressHUD *)showHudWaitingView:(NSString *)prompt
{
    /*
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self promptingTopView] animated:YES];
    hud.labelText = prompt;
//    hud.color = [UIColor flashColorWithRed:97 green:97 blue:97 alpha:1];
    
    hud.minSize = CGSizeMake(132.f, 108.0f);
    return hud;
}

//提示警告信息自动关闭
- (MBProgressHUD *)showHudAuto:(NSString *)text
{
    return [self showMBHudView:text customerView:nil removeAuto:YES];
}

- (MBProgressHUD *)showMBHudView:(NSString *)text customerView:(UIView *)customerView removeAuto:(BOOL)autoremove
{
    [MBProgressHUD hideAllHUDsForView:[self promptingTopView] animated:YES];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[self promptingTopView] animated:YES];
   
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = customerView;
    hud.mode = customerView ? MBProgressHUDModeCustomView : MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    hud.minSize = CGSizeMake(132.f, 108.0f);
    
    if (autoremove) {
        [hud hide:YES afterDelay:1];
    }
    
    return hud;
}

- (MBProgressHUD *)showHudAuto:(NSString *)text andDuration:(NSString *)duration
{
    return [self showMBHudView:text customerView:nil removeAuto:YES andDuration:duration];
}

- (MBProgressHUD *)showMBHudView:(NSString *)text customerView:(UIView *)customerView removeAuto:(BOOL)autoremove andDuration:(NSString *)duration
{
    [MBProgressHUD hideAllHUDsForView:[self promptingTopView] animated:YES];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[self promptingTopView] animated:YES];
    
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = customerView;
    hud.mode = customerView ? MBProgressHUDModeCustomView : MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    hud.cornerRadius = 4.0f;
    hud.margin =10.0f;
    hud.minSize = CGSizeMake(160.f, 40.0f);
    
    // hud.color = [UIColor blackColor];
    hud.alpha = 0.9;
    //
    //    hud.customView.layer.borderColor = [kColor(114, 190, 73) CGColor];
    //     hud.layer.borderColor = [[UIColor blackColor] CGColor];
    //    hud.customView.layer.borderWidth= 5.0f;
    //
    //  hud.color = [UIColor grayColor];
    
    if (autoremove) {
        [hud hide:YES afterDelay:[duration floatValue]];
    }
    
    return hud;
}

///  弹框提示
- (void)alertView:(NSString *)message andtitle:(NSString *)title
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0)
    {
        UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else{
        UIAlertController * alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:NULL];
        
    }
}

@end

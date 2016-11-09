//
//  UIBarButtonItemExtension.h
//  KYDoctor
//
//  Created by Apple on 15-7-15.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIBarButtonItemExtension : NSObject
+ (UIBarButtonItem *)leftButtonItem:(SEL) selector andTarget:(id) target;
//  右侧按钮
+ (UIBarButtonItem *)rightButtonItem:(SEL) selector andTarget:(id) target andButtonTitle:(NSString *)title;
//  左侧菜单按钮
+ (UIBarButtonItem *)leftMenuButtonItem:(SEL) selector andTarget:(id) target;
//  左侧返回按钮
+ (UIBarButtonItem *)leftBackButtonItem:(SEL) selector andTarget:(id) target;

+ (UIBarButtonItem *)rightButtonItemForRegister:(NSString *)content;
//  右侧图片按钮
+ (UIBarButtonItem *)rightButtonItem:(SEL) selector andTarget:(id) target andImageName:(NSString *)imageName;
//左侧标题
+ (UIBarButtonItem *)leftTitleItem:(NSString *)content;
//右侧标题
+ (UIBarButtonItem *)rightTitleItem:(NSString *)content;

//  右侧文字
+ (UIBarButtonItem *)rightButtonItem:(SEL) selector andTarget:(id) target andTitleName:(NSString *)tilteName;

+ (UIBarButtonItem *)leftBackWebButtonItem:(SEL) selector andTarget:(id) target;

//  右侧文字
+ (UIBarButtonItem *)rightSaveButtonItem:(SEL) selector andTarget:(id) target andTitleName:(NSString *)tilteName;
@end

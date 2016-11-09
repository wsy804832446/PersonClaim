//
//  NameEditViewController.h
//  KJ
//
//  Created by 王晟宇 on 16/9/28.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//
typedef NS_ENUM(NSInteger,pageTitle){
//    修改姓名页面
    name = 0,
//    修改密码页面跳转2层
    passWord = 1,
    passWord2 = 2
};
#import "BaseViewController.h"

@interface NameEditViewController : BaseViewController
@property (nonatomic,copy) void (^block) (NSString *name);
@property (nonatomic,assign)pageTitle pageTitle;
//上页传过来的文本信息
@property (nonatomic,copy)NSString *text;
@end

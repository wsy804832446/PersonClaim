//
//  UIBarButtonItemExtension.m
//  KYDoctor
//
//  Created by Apple on 15-7-15.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "UIBarButtonItemExtension.h"

@implementation UIBarButtonItemExtension
+ (UIBarButtonItem *)leftButtonItem:(SEL) selector andTarget:(id) target
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 22, 22);
    
    return [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

+ (UIBarButtonItem *)leftMenuButtonItem:(SEL) selector andTarget:(id) target
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"ic_more"] forState:UIControlStateNormal];
    [searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 20, 25);
    
    return [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}
+ (UIBarButtonItem *)leftBackButtonItem:(SEL) selector andTarget:(id) target
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"backbtnimg"] forState:UIControlStateNormal];
    [searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 26, 26);
    return [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}
+ (UIBarButtonItem *)rightButtonItemForRegister:(NSString *)content
{
    UILabel *lblRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    [lblRight setTextAlignment:NSTextAlignmentRight];
    lblRight.font = [UIFont systemFontOfSize:14];
    lblRight.textColor = [UIColor whiteColor];
    lblRight.text = content;
    
    return [[UIBarButtonItem alloc] initWithCustomView:lblRight];
}

//  右侧按钮
+ (UIBarButtonItem *)rightButtonItem:(SEL) selector andTarget:(id) target andButtonTitle:(NSString *)title;
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitleColor:[UIColor colorWithHEX:0xffffff] forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 30, 16);
    
    return [[UIBarButtonItem alloc] initWithCustomView:rightButton];

}

//  右侧图片按钮
+ (UIBarButtonItem *)rightButtonItem:(SEL) selector andTarget:(id) target andImageName:(NSString *)imageName
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 18, 18);
    
    return [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

+ (UIBarButtonItem *)leftTitleItem:(NSString *)content
{
    UILabel *lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width/3*2, 25)];
    [lblLeft setTextAlignment:NSTextAlignmentLeft];
    lblLeft.font = [UIFont boldSystemFontOfSize:18];
    lblLeft.textColor = [UIColor colorWithHEX:0x333333];
    lblLeft.text = content;
    
    return [[UIBarButtonItem alloc] initWithCustomView:lblLeft];
}

+ (UIBarButtonItem *)rightTitleItem:(NSString *)content
{
    UILabel *lblRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceSize.width/2, 25)];
    [lblRight setTextAlignment:NSTextAlignmentRight];
    lblRight.font = [UIFont boldSystemFontOfSize:13];
    lblRight.textColor = [UIColor colorWithHEX:0x333333];
    lblRight.text = content;
    
    return [[UIBarButtonItem alloc] initWithCustomView:lblRight];
}

//  右侧文字
+ (UIBarButtonItem *)rightButtonItem:(SEL) selector andTarget:(id) target andTitleName:(NSString *)tilteName
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 0, 30);
    [rightButton setTitleColor:[UIColor colorWithHexString:Colorwhite] forState:UIControlStateNormal];
    [rightButton setTitle:tilteName forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    rightButton.frame = CGRectMake(0, 0, 17.5 *tilteName.length, 20);


    return [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
+ (UIBarButtonItem *)leftBackWebButtonItem:(SEL) selector andTarget:(id) target{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"back_web"] forState:UIControlStateNormal];
    [searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    return [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

//  右侧文字
+ (UIBarButtonItem *)rightSaveButtonItem:(SEL) selector andTarget:(id) target andTitleName:(NSString *)tilteName
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 0, 30);
    [rightButton setTitleColor:[UIColor colorWithHEX:0x333333] forState:UIControlStateNormal];
    [rightButton setTitle:tilteName forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    rightButton.frame = CGRectMake(0, 0, 17 *tilteName.length, 30);
    
    
    return [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
@end

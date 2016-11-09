//
//  UIScreen+Extension.m
//  CheShifu
//
//  Created by YDJ on 13-6-3.
//  Copyright (c) 2013年 GuanQinglong. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGFloat)screenScale_Ext
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5) {
            scale = 2.0;
        }
    }
    return scale;
}

@end

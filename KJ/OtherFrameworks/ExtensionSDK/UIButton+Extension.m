//
//  UIButton+Extension.m
//  NR
//
//  Created by 范英强 on 15/9/11.
//  Copyright (c) 2015年 范英强. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>
const char sIsFinish;
@implementation UIButton (Extension)

- (void)setIsFinish:(NSString * )isFinish{
    objc_setAssociatedObject(self, &sIsFinish, isFinish, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)isFinish
{
    return objc_getAssociatedObject(self, &sIsFinish);
}
@end

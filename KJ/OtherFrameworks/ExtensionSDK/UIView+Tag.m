//
//  UIView+Tag.m
//  KYDoctor
//
//  Created by Apple on 15-7-27.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "UIView+Tag.h"
#import <objc/runtime.h>

const char sIndexPath;
@implementation UIView (Tag)


- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, &sIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, &sIndexPath);
}

@end

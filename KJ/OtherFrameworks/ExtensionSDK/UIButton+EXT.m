//
//  UIButton+EXT.m
//  JYCarServer
//
//  Created by Apple on 15-7-1.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "UIButton+EXT.h"

@implementation UIButton (EXT)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title withSize:(CGSize) size forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    
    
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-18,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
//    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [self.titleLabel setTextColor:[UIColor redColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

/*
 
 - (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
 //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
 
 CGSize titleSize = [title sizeWithFont:HELVETICANEUEMEDIUM_FONT(12.0f)];
 [self.imageView setContentMode:UIViewContentModeCenter];
 [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
 0.0,
 0.0,
 0.0)];
 [self setImage:image forState:stateType];
 
 [self.titleLabel setContentMode:UIViewContentModeCenter];
 [self.titleLabel setBackgroundColor:[UIColor clearColor]];
 [self.titleLabel setFont:HELVETICANEUEMEDIUM_FONT(12.0f)];
 [self.titleLabel setTextColor:COLOR_ffffff];
 [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
 0.0,
 0.0,
 0.0)];
 [self setTitle:title forState:stateType];
 }
 
 */
@end

//
//  NSString+Size.h
//  JRJNews
//
//  Created by Mr.Yang on 14-4-16.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)

//  根据屏幕宽度计算高度
- (CGSize)sizeWithFont:(UIFont *)font;

//  根据maxSize计算宽度或者高度
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size;
/**
 *  根据Font和宽度计算高度
 *
 *  @param font     字体大小
 *  @param labWidth 宽度
 *
 *  @return 高度
 */
- (CGFloat)getLabelHeightForFont:(UIFont *)font maxWidth:(CGFloat)labWidth;

@end

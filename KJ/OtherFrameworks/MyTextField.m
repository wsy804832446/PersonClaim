//
//  MyTextField.m
//  KJ
//
//  Created by 王晟宇 on 16/9/29.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.inset, bounds.origin.y, bounds.size.width -self.inset, bounds.size.height);//更好理解些
    return inset;
}
// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.inset, bounds.origin.y, bounds.size.width-self.inset, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.inset, bounds.origin.y, bounds.size.width-self.inset, bounds.size.height);//更好理解些
    return inset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  UIColor+ColorExtension.h
//  MRColor
//
//  Created by Mr.Yang on 13-7-26.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  HTBlackColor           [UIColor blackColor]
#define  HTDarkGrayColor        [UIColor darkGrayColor]
#define  HTLightGrayColor       [UIColor lightGrayColor]
#define  HTWhiteColor           [UIColor whiteColor]
#define  HTGrayColor            [UIColor grayColor]
#define  HTRedColor             [UIColor redColor]
#define  HTGreenColor           [UIColor greenColor]
#define  HTBlueColor            [UIColor blueColor]
#define  HTCyanColor            [UIColor cyanColor]
#define  HTYellowColor          [UIColor yellowColor]
#define  HTMagentaColor         [UIColor magentaColor]
#define  HTOrangeColor          [UIColor orangeColor]
#define  HTPurpleColor          [UIColor purpleColor]
#define  HTBrownColor           [UIColor brownColor]


#define  HTClearColor           [UIColor clearColor]
#define  HTRandomColor          [UIColor randomColor];

#define  HTFlashColor(red1, green1, blue1, alpha1)    \
                                [UIColor flashColorWithRed:red1 \
                                                       green:green1 \
                                                       blue:blue1 \
                                                       alpha:alpha1]

#define  HTHexColor(hex)        [UIColor colorWithHEX:hex]

#define  HTColorWithPatternImage(image)    \
                                [UIColor colorWithPatternImage:image]

#define  HTColorWithPatternImageName(imageName) \
                                [UIColor colorWithPatternImageName:imageName]
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
@interface UIColor (ColorExtension)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHEX:(uint)color;
+ (NSArray*)colorForHex:(NSString *)hexColor;
+ (UIColor *)randomColor;
+ (UIColor *)flashColorWithRed:(uint)red green:(uint)green blue:(uint)blue alpha:(float)alpha;
+ (UIColor *)colorWithPatternImageName:(NSString *)imageName;

/*颜色:得到16#转rgb   郭海彬增加*/
+ (UIColor *) callColorFromHexRGB:(NSString *) inColorString;
@end

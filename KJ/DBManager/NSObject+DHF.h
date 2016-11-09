//
//  NSObject+DHF.h
//  KJ
//
//  Created by iOSDeveloper on 16/5/13.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DHF)

- (NSDictionary *)propertyList:(BOOL)isWrite;
- (NSDictionary *)toDictionary;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

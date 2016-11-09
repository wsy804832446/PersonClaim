//
//  JYSqliteManager.h
//  GuGuHelp
//
//  Created by JY on 15/6/3.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import <Foundation/Foundation.h>

/// sqlite 操作类
@interface JYSqliteManager : NSObject

+ (id)shareSqliteManger;
/// 创建表
- (void)createDatabaseAndTable;
//...各个操作方法

@end

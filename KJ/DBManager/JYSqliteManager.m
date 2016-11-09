//
//  JYSqliteManager.m
//  GuGuHelp
//
//  Created by JY on 15/6/3.
//  Copyright (c) 2015年 jingyoutimes. All rights reserved.
//

#import "JYSqliteManager.h"
#import "FMDB.h"

@interface JYSqliteManager ()

@property (nonatomic,strong) FMDatabaseQueue *databaseQueue;

@end

static JYSqliteManager *jySqliteManager = nil;
@implementation JYSqliteManager

+ (id)shareSqliteManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jySqliteManager = [[self alloc] init];
    });
    return jySqliteManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (jySqliteManager == nil) {
            //  此处注意要调用父类的方法
            jySqliteManager = [super allocWithZone:zone];
            
        }
    });
    return jySqliteManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //  创建数据库和表
       // [self createDatabaseAndTable];
        
    }
    return self;
}

- (id)copy
{
    return [[self class] shareSqliteManger];
}

- (id)mutableCopy
{
    return [[self class] shareSqliteManger];
}

- (FMDatabaseQueue *)databaseQueue
{
    if (!_databaseQueue) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    }
    return _databaseQueue;
}


//  创建所有表
- (void)createDatabaseAndTable
{
    
    NSString *lp_FlowSql = nil;
    NSString *lp_Flow_TaskSql = nil;
    [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL handle_LP_FlowSql = [db executeUpdate:lp_FlowSql];
        BOOL handle_LP_Flow_TaskSql = [db executeUpdate:lp_Flow_TaskSql];
        if (handle_LP_FlowSql) {
            NSLog(@"LP_FLOW表创建完成");
        } else {
            NSLog(@"LP_FLOW表创建失败");
        }
        
        if (handle_LP_Flow_TaskSql) {
            NSLog(@"LP_Flow_Task创建完成");
        } else {
            NSLog(@"LP_Flow_Task表创建失败");
        }
        
        
    }];
    [self.databaseQueue close];
}


- (NSString *)dbPath
{
    NSString *dbPath = [DocumentPath stringByAppendingPathComponent:@"database"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        [fileManager createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"dbpath:%@",dbPath);
    
    NSString *dbSubPath = [dbPath stringByAppendingPathComponent:DatabaseName];
    
    
    return dbSubPath;
}


@end

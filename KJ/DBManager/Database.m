//
//  Database.m
//  KJ
//
//  Created by iOSDeveloper on 16/5/13.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "Database.h"
#import "NSObject+DHF.h"
#import "FMDatabaseAdditions.h"

@implementation Database
+(NSString*)filePath:(NSString *)fileName
{
    NSString *path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        if (fileName&& [fileName length]!=0) {
            path=[path stringByAppendingPathComponent:fileName];
        }
    }
    else{
        NSLog(@"指定目录不存在");
    }
    
    return path;
}
+(Database*)sharedDatabase
{
    static Database *database;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        database=[[Database alloc] init];
    });
    return database;
}
-(instancetype)init
{
    if (self=[super init]) {
        NSString *dbPath = [self copyFile2Documents:@"1.db"];
        myDB=[[FMDatabase alloc] initWithPath:dbPath];
        NSLog(@"%@",dbPath);
        //打开数据库
        if ([myDB open]) {
            //创建表
            //子类要重新调用此方法，完成和应用相关的表的创建
            [self createTable:nil];
        }
        
    }
    return self;
}
-(NSString*) copyFile2Documents:(NSString*)fileName
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    //    NSError *error;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    
    NSString *destPath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
    if(![fileManager fileExistsAtPath:destPath]){
        
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        [doc stringByAppendingPathComponent:@"1.db"];
    }
    return destPath;
}
//根据模型获得创建它的表语句
-(NSString*)createTablePropertyListSQL:(id)modelObject
{
    NSDictionary *dict=[modelObject propertyList:NO];
    NSString *sql= [[dict allKeys] componentsJoinedByString:@" text,"];
    sql=[sql stringByAppendingString:@" text"];
    NSLog(@"%@",sql);
    return sql;
}
//根据传入的模型类名数组，创建以类名为表名的所有表
-(void)createTable:(NSArray*)modelNameArray
{
    NSString * tableSql=@"CREATE TABLE IF NOT EXISTS %@(no integer PRIMARY KEY AUTOINCREMENT,%@)";
    //获得每一个横型类名字符串
    for (NSString *modelName in modelNameArray) {
        //转成类
        Class newClass=NSClassFromString(modelName);
        if (newClass) {
            //获得对应这个模型的建表语句
            NSString *createSql=[self createTablePropertyListSQL:[[newClass alloc] init]];
            NSString *sql=[NSString stringWithFormat:tableSql,modelName,createSql];
            if (![self isTableOK:modelName]) {
                NSLog(@"创建新表:%@",sql);
                BOOL sucess=[myDB executeUpdate:sql];
                if (!sucess) {
                    NSLog(@"创建表失败:%@",[myDB lastErrorMessage]);
                }else{
                    NSLog(@"成功");
                }
            }
        }
    }
}


-(void)insertItem:(id)object
{
    NSDictionary *propertyDict=[object propertyList:YES];
    NSArray *propertyList=[propertyDict allKeys];
    NSArray *propertyValue=[propertyDict allValues];
    
    NSString *itemsql=[propertyList componentsJoinedByString:@","];
    
    NSMutableString *valueSql=[NSMutableString string];
    for (int i=0;i<[propertyList count];i++) {
        if (i==0) {
            [valueSql appendFormat:@"?"];
        }
        else{
            [valueSql appendFormat:@",?"];
        }
    }
    //类名就是表名
    NSString *tableName=NSStringFromClass([object class]);
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)",tableName,itemsql,valueSql];
    // NSLog(@"%@",sql);
    BOOL success=[myDB executeUpdate:sql withArgumentsInArray:propertyValue];
    if (!success) {
        NSLog(@"插入失败:%@",[myDB lastErrorMessage]);
    }
}
//批量插入
-(void)insertArray:(NSArray *)array
{
    [myDB beginTransaction];
    for (id object in array) {
        [self insertItem:object];
    }
    [myDB commit];
}

-(NSArray*)selectData:(NSString *)title subtitle:(NSString *)subtitle keyWord:(NSString *)keyWord model:(id)model
{
    NSMutableArray *array=[NSMutableArray array];
    
    NSDictionary *propertyDict=[model propertyList:NO];
    NSArray *propertyList=[propertyDict allKeys];
    NSString *itemsql=[propertyList componentsJoinedByString:@","];
    
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    
    //    NSString *str1;
    //    NSString *str2;
    //    if (title) {
    //        str1=[NSString stringWithFormat:@"%@=?",title];
    //    }
    //    if (subtitle) {
    //        str2=[NSString stringWithFormat:@"%@=?",subtitle];
    //    }
    if (title && subtitle && keyWord) {
        NSString *key=[NSString stringWithFormat:@"%@%@%@",@"%%",keyWord,@"%%"];
        sql=[NSString stringWithFormat:@"%@ WHERE %@=? AND %@=? AND title like ?",sql,title,subtitle];
        
        //NSLog(@"sql:%@",sql);
        FMResultSet *rs;
        rs=[myDB executeQuery:sql,[model valueForKey:title],[model valueForKey:subtitle],key];
        
        while ([rs next]) {
            NSDictionary *dict=[rs resultDictionary];
            id object=[[[model class] alloc] init];
            [object setValuesForKeysWithDictionary:dict];
            [array addObject:object];
        }
    }else{
        FMResultSet *rs;
        rs=[myDB executeQuery:sql];
        
        while ([rs next]) {
            NSDictionary *dict=[rs resultDictionary];
            id object=[[[model class] alloc] init];
            [object setValuesForKeysWithDictionary:dict];
            [array addObject:object];
        }
    }
    
    return array;
}

-(NSArray*)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model grounBy:(NSString *)groupBy orderBy:(NSString *)orderBy where:(NSString *)whereStr
{
    NSDictionary *propertyDict=[model propertyList:NO];
    NSArray *propertyList=[propertyDict allKeys];
    
    NSString *itemsql=[propertyList componentsJoinedByString:@","];
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    if (whereStr) {
        sql=[NSString stringWithFormat:@"%@ WHERE %@=?",sql,whereStr];
    }
    if (groupBy) {
        sql=[NSString stringWithFormat:@"%@ GROUP BY %@",sql,groupBy];
    }
    if (orderBy) {
        sql=[NSString stringWithFormat:@"%@ ORDER BY %@",sql,orderBy];
    }
    //如果读取的数据条数不为零，加查询限制
    if (count!=0) {
        sql=[NSString stringWithFormat:@"%@ LIMIT %ld,%ld",sql,startIndex,count];
    }
    
    FMResultSet *rs;
    if (whereStr) {
        rs=[myDB executeQuery:sql,[model valueForKey:whereStr]];
        NSLog(@"休闲%@%@",sql,[model valueForKey:whereStr]);
    }
    else{
        rs=[myDB executeQuery:sql];
    }
    
    NSMutableArray *resultArray=[NSMutableArray array];
    while ([rs next]) {
        NSDictionary *dict=[rs resultDictionary];
        id object=[[[model class] alloc] init];
        [object setValuesForKeysWithDictionary:dict];
        [resultArray addObject:object];
    }
    return resultArray;
}
-(NSArray *)readData:(id)model LikeName:(NSString *)likeName{
    NSMutableArray *array=[NSMutableArray array];
    NSDictionary *propertyDict=[model propertyList:NO];
    NSArray *propertyList=[propertyDict allKeys];
    NSString *itemsql=[propertyList componentsJoinedByString:@","];
    //    select * from edu_university where name like '%北京%' or py_name like '%北京%'
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    if (likeName) {
        //        sql=[NSString stringWithFormat:@"%@ WHERE %@ LIKE %@",sql,@"name",[NSString stringWithFormat:@"%@%@%@",@"'%",likeName,@"%'"]];
        sql=[NSString stringWithFormat:@"%@ WHERE %@ LIKE %@ OR %@ LIKE %@",sql,@"name",[NSString stringWithFormat:@"%@%@%@",@"'%",likeName,@"%'"],@"py_name",[NSString stringWithFormat:@"%@%@%@",@"'%",likeName,@"%'"]];
        FMResultSet *rs;
        rs = [myDB executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dict=[rs resultDictionary];
            id object=[[[model class] alloc] init];
            [object setValuesForKeysWithDictionary:dict];
            [array addObject:object];
        }
    }else{
        FMResultSet *rs;
        rs=[myDB executeQuery:sql];
        
        while ([rs next]) {
            NSDictionary *dict=[rs resultDictionary];
            id object=[[[model class] alloc] init];
            [object setValuesForKeysWithDictionary:dict];
            [array addObject:object];
        }
    }
    return array;
}
//查询字段
-(NSString *)readData:(id)model Name:(NSString *)name{
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    NSString *sql=[NSString stringWithFormat:@"SELECT id FROM %@ WHERE name='%@'",tableName,name];
    FMResultSet *rs;
    rs=[myDB executeQuery:sql];
    
    while ([rs next]) {
        return [rs stringForColumn:@"id"];
    }
    return @"";
}

#pragma mark-删除NewHouseModel中收藏的数据
-(void)delete:(NSString *)value
{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM NewHouseModel WHERE hid=%@",value];
    
    BOOL success=[myDB executeUpdate:sql];
    if (!success) {
        NSLog(@"删除失败:%@",[myDB lastErrorMessage]);
    }
}
//查询NewHouseModel中得数据
-(BOOL)select:(NSString *)value{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM NewHouseModel WHERE hid=%@",value];
    
    FMResultSet *rs;
    rs=[myDB executeQuery:sql];
    
    while ([rs next]) {
        return YES;
    }
    return NO;
}


-(NSArray*)selectDataForJobId:(NSInteger)jobId model:(id)model
{
    NSMutableArray *array=[NSMutableArray array];
    //
    //    NSDictionary *propertyDict=[model propertyList:NO];
    //  //  NSArray *propertyList=[propertyDict allKeys];
    NSString *sql=[NSString stringWithFormat:@"SELECT app_level.id as level_id, app_level.level_title as level_name,app_rank.id as rank_id,app_rank.level_title as rank_name from app_rank_level app_level LEFT JOIN app_rank_level app_rank on app_rank.id = app_level.parent_id where app_level.job_id = %li and app_level.parent_id > 0",jobId];
    
    FMResultSet *rs;
    rs=[myDB executeQuery:sql];
    
    while ([rs next]) {
        NSDictionary *dict=[rs resultDictionary];
        id object=[[[model class] alloc] init];
        [object setValuesForKeysWithDictionary:dict];
        [array addObject:object];
    }
    
    return array;
}

-(NSArray*)selectDataForLevleId:(NSInteger)levleIdId andRankId:(NSInteger)rankId model:(id)model{
    NSMutableArray *array=[NSMutableArray array];
    NSString *sql=[NSString stringWithFormat:@"SELECT app_level.id as level_id, app_level.level_title as level_name,app_rank.id as rank_id,app_rank.level_title as rank_name from app_rank_level app_level LEFT JOIN app_rank_level app_rank on app_rank.id = app_level.parent_id where app_level.job_id = 1 and app_level.parent_id > 0 and app_level.id = %li and app_rank.id = %li",levleIdId,rankId];
    
    FMResultSet *rs;
    rs=[myDB executeQuery:sql];
    
    while ([rs next]) {
        NSDictionary *dict=[rs resultDictionary];
        id object=[[[model class] alloc] init];
        [object setValuesForKeysWithDictionary:dict];
        [array addObject:object];
    }
    
    return array;
}
- (BOOL)isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [myDB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}
//表中插入字段
-(void)insertDataName:(NSString *)name andModel:(id)model{
    NSString * tableName = NSStringFromClass([model class]);
    if ([myDB columnExists:name inTableWithName:tableName]) {
        NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET %@=? ",tableName,name];
        [myDB executeUpdate:update];
    }else{
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ text",tableName,name];
        [myDB executeUpdate:sql];
        NSString *update = [NSString stringWithFormat:@"UPDATE %@ SET %@=? ",tableName,name];
        [myDB executeUpdate:update];
    }
}
@end

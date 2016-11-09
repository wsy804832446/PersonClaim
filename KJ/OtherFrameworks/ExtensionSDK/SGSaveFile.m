//
//  SGSaveFile.m
//  PowerOnHD
//
//  Created by Srain on 13-7-9.
//  Copyright (c) 2013年 lu yingzhi. All rights reserved.
//

#import "SGSaveFile.h"

@implementation SGSaveFile

+(BOOL)isFileExists:(NSString*)filePath
{
	return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+(void)createNewDir:(NSString*)path
{
    if (![self isFileExists:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

+(NSString*)getDocumentsPath
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getPublicPath
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),@"public"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getCachePath
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
    
}
+(NSString*)getPublicPathAppendPath:(NSString*)path
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/Documents/%@/%@", NSHomeDirectory(),@"public",path];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getAccountPath
{
    NSString *account=[self getObjectFromSystemWithKey:@"username"];
    NSString *stringPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),account];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getProjectPath//项目
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@",[self getAccountPath],[self getObjectFromSystemWithKey:@"project_id"]];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getOfflinePath//离线文件
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@",[self getProjectPath],@"Offline"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getADVPath//
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@",[self getDocumentsPath],@"adv"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getMatterPath
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@",[self getProjectPath],@"matter"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}

+(NSString*)getOperatePath:(NSString*)first withPath:(NSString*)second
{
    NSString *stringPath = [NSString stringWithFormat:@"%@/%@",first,second];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL find = [fileManager fileExistsAtPath:stringPath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:stringPath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
	return stringPath;
}
+(NSString*)getFilePath:(NSString*)file
{
    NSString *filePath=nil;
    NSArray *tempArray=[file componentsSeparatedByString:@"/"];
    if (tempArray!=nil&&[tempArray count]>1) {
        filePath=[tempArray objectAtIndex:0];
        for (int i=1; i<[tempArray count]-1; i++) {
            NSString *tempString=[tempArray objectAtIndex:i];
            filePath=[filePath stringByAppendingPathComponent:tempString];
        }
    }
    return filePath;
}
+(NSString*)getLastFileName:(NSString*)file
{
    NSString *lastString=nil;
    NSArray *tempArray=[file componentsSeparatedByString:@"/"];
    if (tempArray!=nil&&[tempArray count]>0) {
        lastString=[tempArray objectAtIndex:tempArray.count-1];
    }
    return lastString;
}
+(void)writeString:(NSString*)string toDocumentPath:(NSString*)path;
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath=[self getFilePath:path];
	BOOL find = [fileManager fileExistsAtPath:filePath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:filePath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
    [string writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
}
+(NSString*)getStringFromDocumentPath:(NSString*)path;
{
    NSString *stringPath=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return stringPath;
}
+(void)writeData:(NSData*)data toDocumentPath:(NSString*)path;
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath=[self getFilePath:path];
	BOOL find = [fileManager fileExistsAtPath:filePath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:filePath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
    [data writeToFile:path atomically:NO];
}
+(NSData*)getDataFromDocumentPath:(NSString*)path;
{
    return [NSData dataWithContentsOfFile:path];
}
+(void)writeImage:(UIImage*)image toDocumentPath:(NSString*)path
{
    NSData *imageData= UIImagePNGRepresentation(image);
    [SGSaveFile writeData:imageData toDocumentPath:path];
}
+(UIImage*)getImageFromDocumentPath:(NSString*)path
{
    NSData *imageData=[SGSaveFile getDataFromDocumentPath:path];
    return [UIImage imageWithData:imageData];
}
+(void)writeArray:(NSMutableArray*)array toDocumentPath:(NSString*)path;
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath=[self getFilePath:path];
	BOOL find = [fileManager fileExistsAtPath:filePath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:filePath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
    [array writeToFile:path atomically:NO];
}
+(NSMutableArray*)getArrayFromDocumentPath:(NSString*)path;
{
    NSMutableArray *array=[NSMutableArray arrayWithContentsOfFile:path];
    return array;
}
+(void)writeDictionary:(NSMutableDictionary*)dictionary toDocumentPath:(NSString*)path;
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath=[self getFilePath:path];
	BOOL find = [fileManager fileExistsAtPath:filePath];
	if (!find)
	{
		[fileManager createDirectoryAtPath:filePath
		       withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
	}
    [dictionary writeToFile:path atomically:NO];
}
+(NSMutableDictionary*)getDictionaryFromDocumentPath:(NSString*)path;
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dic;
}
+(void)saveObjectToSystem:(id)object forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getObjectFromSystemWithKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}
+(id)getIdFromObjectWithKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+(id)getArrayFromSystemWithKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}
+(void)removeObjectFromSystemWithKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
+(void)removeFileWithPath:(NSString*)path
{
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    [defaultManager  removeItemAtPath:path error:nil];
}
+(void)saveDataObjectToSystem:(id)object forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getDataIdFromObjectWithKey:(NSString*)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
   return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end


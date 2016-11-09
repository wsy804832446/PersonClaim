//
//  SGSaveFile.h
//  PowerOnHD
//
//  Created by Srain on 13-7-9.
//  Copyright (c) 2013年 lu yingzhi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SGSaveFile : NSObject

+(BOOL)isFileExists:(NSString*)filePath;

+(void)createNewDir:(NSString*)path;

+(NSString*)getDocumentsPath;

+(NSString*)getCachePath;

+(NSString*)getPublicPath;

+(NSString*)getPublicPathAppendPath:(NSString*)path;

+(NSString*)getAccountPath;

+(NSString*)getProjectPath;

+(NSString*)getOfflinePath;

+(NSString*)getADVPath;

+(NSString*)getMatterPath;

+(NSString*)getOperatePath:(NSString*)first withPath:(NSString*)second;

//document save
+(void)writeString:(NSString*)string toDocumentPath:(NSString*)path;

+(NSString*)getStringFromDocumentPath:(NSString*)path;

+(void)writeData:(NSData*)data toDocumentPath:(NSString*)path;

+(NSData*)getDataFromDocumentPath:(NSString*)path;

+(void)writeImage:(UIImage*)image toDocumentPath:(NSString*)path;

+(UIImage*)getImageFromDocumentPath:(NSString*)path;

+(void)writeArray:(NSMutableArray*)array toDocumentPath:(NSString*)path;

+(NSMutableArray*)getArrayFromDocumentPath:(NSString*)path;

+(void)writeDictionary:(NSMutableDictionary*)dictionary toDocumentPath:(NSString*)path;

+(NSMutableDictionary*)getDictionaryFromDocumentPath:(NSString*)path;

//system save
+(void)saveObjectToSystem:(id)object forKey:(NSString*)key;

+(id)getObjectFromSystemWithKey:(NSString*)key;

+(void)removeObjectFromSystemWithKey:(NSString*)key;

+(void)removeFileWithPath:(NSString*)path;

+(id)getArrayFromSystemWithKey:(NSString*)key;

+(id)getIdFromObjectWithKey:(NSString*)key;

+(void)saveDataObjectToSystem:(id)object forKey:(NSString*)key;

+(id)getDataIdFromObjectWithKey:(NSString*)key;
@end

//
//  LocalTalk.h
//  TRx
//
//  Created by John Cotham on 3/10/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTalk : NSObject

/*Will uncomment methods as they are implemented 
 ***Add or let me know if you have something you want implemented ***/



/* Store @"tempId" locally before actual values loaded from DB
 * Used so that app will work without server access */
+(BOOL)localStoreTempPatientId;
+(BOOL)localStoreTempRecordId;


+(BOOL)localStoreValue:(NSString *)value forQuestionId:(NSString *)questionId;

+(BOOL)localStorePatientMetaData:(NSString *)key
                           value:(NSString *)value;
+(NSString *)localGetPatientMetaData:(NSString *)key;


+(BOOL)localStorePortrait:(UIImage *)image;
+(BOOL)loadPortraitImageIntoLocal:(NSString *)patientId;
+(UIImage *)localGetPortrait;



+(NSString *)localGetPatientId;
+(NSString *)localGetRecordId;


+(void)localClearPatientData;

+(BOOL)addNewPatientAndSynchData;
+(BOOL)synchPatientData;


+(BOOL)clearLocalThenLoadPatientRecordIntoLocal:(NSString *)recordId;
+(BOOL)loadPatientRecordIntoLocal:(NSString *)recordId;


+(NSString *)getEnglishLabel:(NSString *)questionId;
+(NSString *)getSpanishLabel:(NSString *)questionId;

//+(BOOL)cachePatientData;
//+(BOOL)loadDataFromCacheIntoLocal:(NSString *)fname;
//+(BOOL)isUnsynched;

//+(UIImage *)localGetPatientImage:(NSString *)patientId;

/* for testing */
+(void)printLocal;
/* end for testing */


@end

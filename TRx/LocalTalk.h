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

+(BOOL)localStorePortrait:(UIImage *)image;
+(UIImage *)localGetPortrait;

//+(BOOL)loadPortraitImageFromServer:(NSString *)patientId;


//+(UIImage *)localGetPatientImage:(NSString *)patientId;
+(NSString *)localGetPatientId;
+(NSString *)localGetRecordId;
//+(NSString *)localGetPatientName;

+(void)localClearPatientData;

//+(BOOL)isUnsynched;
+(BOOL)synchPatientData;



+(BOOL)clearLocalThenLoadPatientRecordIntoLocal:(NSString *)recordId;
+(BOOL)loadPatientRecordIntoLocal:(NSString *)recordId;


+(NSString *)getEnglishLabel:(NSString *)questionId;
+(NSString *)getSpanishLabel:(NSString *)questionId;

//+(BOOL)cachePatientData;
//+(BOOL)loadDataFromCacheIntoLocal:(NSString *)fname;

@end

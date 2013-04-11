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
+(BOOL)localStoreAudio:(id)audioData
              fileName:(NSString *)fileName;
+(BOOL)localStorePortrait:(UIImage *)image;



+(NSMutableArray *)localGetPatientList;
+(NSString *)localGetPatientMetaData:(NSString *)key;
+(UIImage *)localGetPortrait;
+(id)localGetAudio:(NSString *)fileName;

+(NSString *)localGetPatientId;
+(NSString *)localGetRecordId;



+(BOOL)loadPortraitImageIntoLocal:(NSString *)patientId;
+(BOOL)loadPatientRecordIntoLocal:(NSString *)recordId;


+(void)localClearPatientData;


+(BOOL)clearLocalThenLoadPatientRecordIntoLocal:(NSString *)recordId;





//+(BOOL)cachePatientData;
//+(BOOL)loadDataFromCacheIntoLocal:(NSString *)fname;
//+(BOOL)isUnsynched;

//+(UIImage *)localGetPatientImage:(NSString *)patientId;


/* for testing */
+(void)printLocal;
+(void)printAudio;
/* end for testing */


@end

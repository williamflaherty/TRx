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

//+(BOOL)loadPatientRecordIntoLocal:(NSString *)recordId;
//
+(BOOL)localStorePatientId:(NSString *)patientId;
+(BOOL)localStoreRecordId:(NSString *)recordId;
+(BOOL)localStoreValue:(NSString *)value forQuestionId:(NSString *)questionId;
//+(BOOL)localStoreImage:(UIImage *)image;
//
//+(UIImage *)localGetPatientImage:(NSString *)patientId;
+(NSString *)localGetPatientId;
+(NSString *)localGetRecordId;
//+(NSString *)localGetPatientName;
//
//
+(BOOL)localClearPatientData;
//+(BOOL)isUnsynched;
//+(BOOL)synchPatientData;
//
//+(BOOL)cachePatientData;
//+(BOOL)loadDataFromCacheIntoLocal:(NSString *)fname;
//
+(NSString *)getEnglishLabel:(NSString *)questionId;
+(NSString *)getSpanishLabel:(NSString *)questionId;



@end

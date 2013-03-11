//
//  LocalTalk.h
//  TRx
//
//  Created by John Cotham on 3/10/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTalk : NSObject

+(BOOL)loadPatientRecord:(NSString *)recordId;


+(NSString *)getEnglishLabel:(NSString *)questionId;
+(NSString *)getSpanishLabel:(NSString *)questionId;

//synchPatient	//pushes all columns where synched = 0 to database with patientId
//isUnsynched	//returns true if any unsynched columns
//storePatientDataForLater
//
//getEnglishLabel
//getSpanishLabel
//getValue
//storeValue

@end

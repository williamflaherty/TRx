//
//  LocalTalkWrapper.h
//  TRx
//
//  Created by John Cotham on 3/31/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "LocalTalk.h"
#import "Patient.h"
#import "SynchData.h"

@interface LocalTalkWrapper : LocalTalk

+(void)addPatientObjectToLocal:(Patient *)newPatient;
+(BOOL)addNewPatientAndSynchData;
+(Patient *)initPatientFromLocal;


@end

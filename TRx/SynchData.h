//
//  SynchData.h
//  TRx
//
//  Created by John Cotham on 3/25/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface SynchData : NSObject

+(BOOL)addPatientToDatabaseAndSyncData;
+(Patient *)initPatientFromLocal;
@end

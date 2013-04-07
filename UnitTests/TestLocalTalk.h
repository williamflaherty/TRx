//
//  TestLocalTalk.h
//  TRx
//
//  Created by John Cotham on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "LocalTalk.h"
#import "LocalTalkWrapper.h"
#import "Patient.h"
#import "DBTalk.h"

@interface TestLocalTalk : SenTestCase
+(Patient *)initPatient;
@end

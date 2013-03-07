//
//  Patient.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "Patient.h"

@implementation Patient

@synthesize firstName, middleName, lastName, chiefComplaint, photoID;

-(id)initWithFirstName:(NSString *)fn MiddleName:(NSString*) mn LastName:(NSString*)ln ChiefComplaint:(NSString *)c PhotoID:(UIImage*)p{
    self.firstName = fn;
    self.middleName = mn;
    self.lastName = ln;
    self.chiefComplaint = c;
    self.photoID = p;
    
    return  self;
}

@end

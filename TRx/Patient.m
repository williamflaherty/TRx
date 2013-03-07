//
//  Patient.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "Patient.h"

@implementation Patient

@synthesize name, chiefComplaint, photoID;

-(id)initWithName:(NSString *)n ChiefComplaint:(NSString *)c PhotoID:(UIImage*)p{
    self.name = n;
    self.chiefComplaint = c;
    self.photoID = p;
    
    return  self;
}

@end

//
//  Patient.h
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CATARACT,
    HERNIA,
    CLEFT,
    OBGYN,
    UNSPECIFIED
} complaint;

@interface Patient : NSObject{
   
    NSString *firstName, *middleName, *lastName;
    
    NSInteger birthday;
    
    complaint chiefComplaint;
    
    UIImage *photoID;
}

@property(nonatomic,retain) NSString *firstName;
@property(nonatomic,retain) NSString *middleName;
@property(nonatomic,retain) NSString *lastName;

@property(nonatomic,readwrite) NSInteger birthday;

@property(nonatomic, readwrite) complaint chiefComplaint;

@property(nonatomic, retain) UIImage *photoID;

-(id)initWithFirstName:(NSString *)fn MiddleName:(NSString*) mn LastName:(NSString*)ln ChiefComplaint:(complaint)c PhotoID:(UIImage*)p;

@end

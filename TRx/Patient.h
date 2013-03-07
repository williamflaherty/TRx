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
    NSString *name;
    complaint chiefComplaint;
    UIImage *photoID;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic, readwrite) complaint chiefComplaint;
@property(nonatomic, retain) UIImage *photoID;

-(id)initWithName:(NSString*)n ChiefComplaint:(complaint)c PhotoID:(UIImage*)p;

@end

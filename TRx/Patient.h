//
//  Patient.h
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patient : NSObject{
    NSString *name;
    NSString *chiefComplaint;
    UIImage *photoID;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic, readwrite) NSString *chiefComplaint;
@property(nonatomic, retain) UIImage *photoID;

-(id)initWithName:(NSString *)n ChiefComplaint:(NSString *)c PhotoID:(UIImage*)p;

@end

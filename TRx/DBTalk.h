//
//  DBTalk.h
//  TRx
//
//  Created by John Cotham on 2/24/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBTalk : NSObject

{
    NSString *Host;
    
}

//-(UIImage *)getImageFromServer: (NSString *)patientID: (NSURL *)url;
//-(BOOL)addImageToServer: (NSString *)patientID: (UIImage *)image: (NSString *)name;
//
// /* if previous record exists, copies all possible info. Else nothing */
//-(BOOL)addRecord: (NSString *)patientID;
//
//-(BOOL)addPatient: (NSString *)name;
//-(NSString *)getNewPatientID;
//
// /*an array of dictionaries? or a Dicionary with two arrays */
//-(NSArray *)getPatientList;
//

+(NSString *)addPatient:(NSString *)firstName: (NSString *)middleName: (NSString *)lastName:
(NSString *)birthday;

+(NSString *)addRecord:(NSString *)patientId: (NSString *)surgeryTypeId;


+(NSString *) urlEncodeData:(NSString *)str;

@end

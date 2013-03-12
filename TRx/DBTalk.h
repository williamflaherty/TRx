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
    NSString *host;
    NSString *portraitDir;
}


+(NSArray *)getPatientList;
+(NSArray *)getSurgeryList;
+(NSArray *)getDoctorList;

+(UIImage *)getPortraitFromServer:(NSString *)fileName;
+(UIImage *)getThumbFromServer:(NSString *)fileName;
+(UIImage *)getProfilePictureFromServer:(NSString *)patientId;

+(NSString *)addProfilePicture:(UIImage *)picture
                     patientId:(NSString *)patientId;

+(NSString *)addPicture:(UIImage  *)picture
              patientId:(NSString *)patientId
      customPictureName:(NSString *)customPictureName
              isProfile:(NSString *)isProfile;

+(BOOL)sendPictureToServer:(UIImage *)picture
                  fileName:(NSString *)fileName;

+(NSString *)addPatient:(NSString *)firstName
             middleName:(NSString *)middleName
               lastName:(NSString *)lastName
               birthday:(NSString *)birthday;

+(NSString *)addUpdatePatient:(NSString *)firstName
                   middleName:(NSString *)middleName
                     lastName:(NSString *)lastName
                     birthday:(NSString *)birthday
                    patientId:(NSString *)patientId;   /* pass NULL if adding. pass Id if updating */

+(BOOL)deletePatient: (NSString *)patientId;

+(NSString *)addRecord:(NSString *)patientId
         surgeryTypeId:(NSString *)surgeryTypeId
              doctorId:(NSString *)doctorId
              isActive:(NSString *)isActive
            hasTimeout:(NSString *)hasTimeout;

+(NSArray *)getRecordData:(NSString *)recordId;



@end

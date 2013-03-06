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
    
}


+(NSArray *)getPatientList;

+(UIImage *)getPortraitFromServer:(NSString *)fileName;
+(UIImage *)getThumbFromServer:(NSString *)fileName;
+(UIImage *)getProfilePictureFromServer:(NSString *)patientId;

+(NSString *)addPicture:(UIImage *)picture
              pictureId:(NSString *)pictureId
              patientId:(NSString *)patientId
      customPictureName:(NSString *)customPictureName
              isProfile:(NSString *)isProfile;

+(BOOL)sendPictureToServer:(UIImage *)picture
                  fileName:(NSString *)fileName;

+(NSString *)addPatient:(NSString *)firstName
             middleName:(NSString *)middleName
               lastName:(NSString *)lastName
               birthday:(NSString *)birthday;

+(BOOL)deletePatient: (NSString *)patientId;

+(NSString *)addRecord:(NSString *)patientId
         surgeryTypeId:(NSString *)surgeryTypeId;




@end

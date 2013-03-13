//
//  DBTalk.m
//  TRx
//
//  Created by John Cotham on 2/24/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "DBTalk.h"
#import "AFNetworking.h"
#import "NZURLConnection.h"
#import <UIKit/UIKit.h>


@implementation DBTalk


static NSString *host = nil;
static NSString *imageDir = nil;

+(void)initialize{
    host = @"http://www.teamecuadortrx.com/TRxTalk/index.php/";
    imageDir = @"http://teamecuadortrx.com/TRxTalk/Data/images/";
}


+(NSString *)addPatient:(NSString *)firstName
             middleName:(NSString *)middleName
               lastName:(NSString *)lastName
               birthday:(NSString *)birthday {
    return [self addUpdatePatient:firstName middleName:middleName lastName:lastName birthday:birthday patientId:@"NULL"];
}

/*---------------------------------------------------------------------------
 * description: method adds or updates information in the Patient table
 * note: to add a patient, pass NULL as patientId. 
 *       to update patient data, pass patientId string as parameter
 *---------------------------------------------------------------------------*/
+(NSString *)addUpdatePatient:(NSString *)firstName
             middleName:(NSString *)middleName
               lastName:(NSString *)lastName
               birthday:(NSString *)birthday
              patientId:(NSString *)patientId {

    NSString *encodedString = [NSString stringWithFormat:
                               @"%@add/addPatient/%@/%@/%@/%@/%@", host,
                               patientId, firstName, middleName, lastName, birthday];
    
    NSLog(@"encodedString: %@", encodedString);
    
    /* replace initWithContentsOfURL when can test */
    /* need to figure out how to return with blocks */
    
    /*[NZURLConnection getAsynchronousResponseFromURL:encodedString withTimeout:5 completionHandler:^(NSData *response, NSError *error, BOOL timedOut) {
        if (response) {
            NSLog(@"%@", response);
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&jsonError];
            NSDictionary *dic = jsonArray[0];
            NSString *retval = [dic objectForKey:@"@returnValue"];
            NSLog(@"addPicture returned %@", retval);
        }
    }]; */
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        NSLog(@"Is getting patient data: %@\n", dic);
        NSString *retval = (NSString *)[dic objectForKey:@"@returnValue"];
        NSLog(@"retval: %@\n", retval);
        NSLog(@"jsonError: %@", jsonError);
        return retval;
    }
    return NULL;
}

/*---------------------------------------------------------------------------
 * description: method adds record for patient with patientId
 * note: Patient and Record need to be added for patient to show 
         up in getPatientList call
 *---------------------------------------------------------------------------*/
+(NSString *)addRecord:(NSString *)patientId
         surgeryTypeId:(NSString *)surgeryTypeId
              doctorId:(NSString *)doctorId
              isActive:(NSString *)isActive
            hasTimeout:(NSString *)hasTimeout {
    
    NSString *encodedString = [NSString stringWithFormat:@"%@add/record/%@/%@/%@/%@/%@", host,
                               patientId, surgeryTypeId, @"1", isActive, @"0"];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        return [dic objectForKey:@"@returnValue"];
    }
    return NULL;
}


/*---------------------------------------------------------------------------
 * adds profile picture to server and info to database
 * returns: NULL on failure. pictureId otherwise
 *---------------------------------------------------------------------------*/

+(NSString *)addProfilePicture:(UIImage *)picture
                     patientId:(NSString *)patientId {
    
    return [self addPicture:picture
                  patientId:patientId
          customPictureName:@"NULL"
                  isProfile:@"1"
                  directory:@"portraits"];
}

/*---------------------------------------------------------------------------
 * description: method adds picture to server and puts path in database
 * pictureId: NULL if adding picture. pictureId as string if updating
 * isProfile: @"0" -- not profile picture. or @"1" -- is profile picture
 * returns NULL on failure. pictureId otherwise
 *---------------------------------------------------------------------------*/
+(NSString *)addPicture:(UIImage  *)picture
              patientId:(NSString *)patientId
      customPictureName:(NSString *)customPictureName
              isProfile:(NSString *)isProfile
              directory:(NSString *)directory {
    
    NSString *pictureId = nil;
    NSString *fileName = [self getNewPictureName:patientId];
    BOOL added = [self uploadPictureToServer:picture fileName:fileName directory:directory];
    
    if (!added) {
        NSLog(@"Error adding picture");
        return nil;
    }
    
    pictureId = [self addPictureInfoToDatabase:patientId fileName:fileName isProfile:isProfile];
    NSLog(@"value of pictureId: %@", pictureId);
    return pictureId;
}


/*---------------------------------------------------------------------------
 * deletes specified patient and associated records. returns true on success
 *---------------------------------------------------------------------------*/
+(BOOL)deletePatient: (NSString *)patientId {
    NSString *encodedString = [NSString stringWithFormat:@"%@delete/deletePatient/%@", host, patientId];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        NSString *retval = [dic objectForKey:@"@returnValue"];
        NSLog(@"PatientDelete call returned: %@", retval);
        return true;
    }
    NSLog(@"Delete call didn't work: error in PHP");
    return false;
}


/*---------------------------------------------------------------------------
 * description: queries database for a list of patients that have records  <-- assumption!
 * returns: An NSArray of dictionaries with keys: Id, MiddleName, FirstName, IsActive
 *---------------------------------------------------------------------------*/
+(NSArray *)getPatientList {
    NSString *encodedString = [NSString stringWithFormat:@"%@get/patientList/", host];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        //NSLog(@"PatientDelete call returned: %@", retval);
        return jsonArray;
    }
    NSLog(@"getPatientList didn't work: error in PHP");
    return NULL;
    
}


/*---------------------------------------------------------------------------
 * description: gets picture from portrait folder on host
 * current host: teamecuadortrx.com/TRxTalk
 * fileName: "patientId" + "n" + "picNumber" 
 * returns UIImage of specified jpeg
 *---------------------------------------------------------------------------*/

+(UIImage *)getPortraitFromServer:(NSString *)fileName {
    NSString *str = [NSString stringWithFormat:@"%@portraits/%@.jpeg", imageDir, fileName];
    NSURL *url = [NSURL URLWithString:str];
    UIImage *myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:url]];
    return myImage;
}


/*---------------------------------------------------------------------------
 * description: gets picture from thumb folder on host
 * current host: teamecuadortrx.com/TRxTalk
 * fileName: "patientId" + "n" + "picNumber"
 * returns UIImage of specified jpeg
 *---------------------------------------------------------------------------*/
+(UIImage *)getThumbFromServer:(NSString *)fileName {
    NSString *str = [NSString stringWithFormat:@"%@thumbs/%@.jpeg", imageDir, fileName];
    NSURL *url = [NSURL URLWithString:str];
    UIImage *myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:url]];
    return myImage;
}


/*---------------------------------------------------------------------------
 * description: gets list of surgeries with their Id's
 * returns NSArray of dictionaries with keys: Name and Id
 *---------------------------------------------------------------------------*/
+(NSArray *)getSurgeryList {
    NSString *encodedString = [NSString stringWithFormat:@"%@get/surgeryList/", host];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        return jsonArray;
    }
    NSLog(@"getSurgeryList didn't work: error in PHP");
    return NULL;
}

/*---------------------------------------------------------------------------
 * description: gets list of surgeries with their Id's
 * returns NSArray of the LastName of the doctor
 *---------------------------------------------------------------------------*/
+(NSArray *)getDoctorList {
    NSString *encodedString = [NSString stringWithFormat:@"%@get/doctorList/", host];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        return jsonArray;
    }
    NSLog(@"getDoctorList didn't work: error in PHP");
    return NULL;
}


/*---------------------------------------------------------------------------
 * Pass in a patient's recordId. Calls DB to get stored info
 * returns NSArray of Keys and values for each field
 *---------------------------------------------------------------------------*/
+(NSArray *)getRecordData:(NSString *)recordId {
    NSString *encodedString = [NSString stringWithFormat:@"%@get/recordData/", host];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        return jsonArray;
    }
    NSLog(@"getRecordData didn't work: error in PHP");
    return NULL;
    
}



/*---------------------------------------------------------------------------
 * description: queries database for current profile picture
 * returns UIImage of profile picture for specified patient
 *---------------------------------------------------------------------------*/
+(UIImage *)getProfilePictureFromServer:(NSString *)patientId {
    NSString *encodedString = [NSString stringWithFormat:@"%@get/profileURL/%@", host, patientId];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    NSString *fileName;
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        fileName = [dic objectForKey:@"Path"];
        
        return [self getPortraitFromServer:fileName];
    }
    NSLog(@"Error retrieving profile picture");
    return NULL;
}

/*---------------------------------------------------------------------------
 *hope to have this working soon
 *---------------------------------------------------------------------------*/
+(BOOL)uploadPictureToServer:(UIImage *)picture
                    fileName:(NSString *)fileName
                   directory:(NSString *)directory {
    
    NSString *fNameWithSuffix = [NSString stringWithFormat:@"%@.jpeg", fileName];
    
    /*Using AFNetworking. This works, but it seems to still block until picture is uploaded */
    /*all of a sudden much faster */
    /* --works quickly when I don't call addPictureInfoToDatabase */
    /* ----issue was initWithURL ----- need to refactor ----*/
    
    NSURL *url = [NSURL URLWithString:@"http://www.teamecuadortrx.com/TRxTalk/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSData *imageData = UIImageJPEGRepresentation(picture, 0.9);
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:directory, @"directory", nil];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"upload.php" parameters:dic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:fNameWithSuffix mimeType:@"image/jpeg"];
    }];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation start];
    
    return true;
}

/*---------------------------------------------------------------------------
 * Updates a picture path in the database. Need to pass in a pictureId
 * 
 *---------------------------------------------------------------------------*/

+(NSString *)updatePictureInfoInDatabase:(NSString *)pictureId
                               patientId:(NSString *)patientId
                                 newPath:(NSString *)newPath
                              customName:(NSString *)customName
                               isProfile:(NSString *)isProfile {
    return [self pictureInfoToDatabase:pictureId patientId:patientId fileName:newPath
                     customName:customName isProfile:isProfile];
}
/*---------------------------------------------------------------------------
* Adds a picture path to the database. Path is just a filename right now
* 
*---------------------------------------------------------------------------*/

+(NSString *)addPictureInfoToDatabase:(NSString *)patientId
                             fileName:(NSString *)fileName
                            isProfile:(NSString *)isProfile {
    return [self pictureInfoToDatabase:@"NULL" patientId:patientId fileName:fileName
                     customName:@"NULL" isProfile:isProfile];
}


/*---------------------------------------------------------------------------
 * base method for addPicturePathToDatabase and updatePathToDatabase
 * 
 *---------------------------------------------------------------------------*/
+(NSString *)pictureInfoToDatabase:(NSString *)picId
                         patientId:(NSString *)patientId
                          fileName:(NSString *)fileName
                        customName:(NSString *)customName
                         isProfile:(NSString *)isProfile {
    
    NSString *encodedString = [NSString stringWithFormat:@"%@add/picturePathToDatabase/%@/%@/%@/%@/%@", host,
                               picId, patientId, fileName, customName, isProfile];
    NSLog(@"picturePathURL: %@", encodedString);
    
    /* THIS LINE IS THE PROBLEM */
    //NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];

    /* Using Ziebart's code for kicks */
    [NZURLConnection getAsynchronousResponseFromURL:encodedString withTimeout:5 completionHandler:^(NSData *response, NSError *error, BOOL timedOut) {
        if (response) {
            NSLog(@"%@", response);
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&jsonError];
            NSDictionary *dic = jsonArray[0];
            NSString *retval = [dic objectForKey:@"@returnValue"];
            NSLog(@"addPicture returned %@", retval);
        }
    }];
    

    NSLog(@"Error adding picturePath to Database");
    return NULL;
    
}
/*---------------------------------------------------------------------------
 * method concatenates patientId, the letter 'n', and the number of the
 * picture for the patient and returns a name.
 *---------------------------------------------------------------------------*/

+(NSString *) getNewPictureName:(NSString *)patientId {
    NSString *numPicsURL = [NSString stringWithFormat:@"%@get/numPictures/%@", host, patientId];
    NSLog(@"numPicsURL: %@", numPicsURL);
    NSData *numPicsData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:numPicsURL]];
    if (!numPicsData)
        NSLog(@"Error retrieving numPics in method getNewPictureName");
    NSError *jsonError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:numPicsData options:kNilOptions error:&jsonError];
    NSDictionary *dic = jsonArray[0];
    int numPics = [[dic objectForKey:@"numPictures"] intValue];
    NSString *name;
    
    if (numPics < 10)
        name = [NSString stringWithFormat:@"%@n00%d",patientId, numPics];
    else if (numPics < 100)
        name = [NSString stringWithFormat:@"%@n0%d",patientId, numPics];
    else
        name = [NSString stringWithFormat:@"%@n%d",patientId, numPics];
    return name;
}

/*---------------------------------------------------------------------------
 * method encodes and returns a string formatted to pass in a url
 *---------------------------------------------------------------------------*/
+(NSString *) urlEncodeData:(NSString *)str {
    NSString *encodedString = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)str,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUTF8);
    return encodedString;
}





@end

//
//  DBTalk.m
//  TRx
//
//  Created by John Cotham on 2/24/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "DBTalk.h"
#import <UIKit/UIKit.h>


@implementation DBTalk


static NSString *host = nil;
static NSString *imageDir = nil;

+(void)initialize
{
    host = @"http://www.teamecuadortrx.com/TRxTalk/index.php/";
    imageDir = @"http://teamecuadortrx.com/TRxTalk/Data/images/";
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
              patientId:(NSString *)patientId
{

    NSString *encodedString = [NSString stringWithFormat:
                               @"%@add/addPatient/%@/%@/%@/%@/%@", host,
                               patientId, firstName, middleName, lastName, birthday];
    
    NSLog(@"encodedString: %@", encodedString);
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
            hasTimeout:(NSString *)hasTimeout
{
    
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
 * description: method adds picture to server and puts path in database
 * pictureId: NULL if adding picture. pictureId as string if updating
 * isProfile: @"0" -- not profile picture. or @"1" -- is profile picture
 *---------------------------------------------------------------------------*/
+(NSString *)addPicture:(UIImage  *)picture
              pictureId:(NSString *)pictureId
              patientId:(NSString *)patientId
      customPictureName:(NSString *)customPictureName
              isProfile:(NSString *)isProfile
{
    NSString *fileName = [self getNewPictureName:patientId];
    BOOL added = [self sendPictureToServer:picture fileName:fileName];
    
    if (added) {
        pictureId = [self addPicturePathToDatabase:pictureId :patientId :fileName :customPictureName :isProfile];
        
        NSString *encodedString = [NSString stringWithFormat:@"%@add/addPicture/%@/%@/%@/%@/%@", host,
                                   pictureId, patientId, fileName, customPictureName, isProfile];
        
        NSLog(@"encodedString: %@", encodedString);
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
        
        if (data) {
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            NSDictionary *dic = jsonArray[0];
            NSString *retval = [dic objectForKey:@"@returnValue"];
            NSLog(@"addPicture returned %@", retval);
            return retval;
        }
    }
    NSLog(@"Error adding picture");
    return NULL;
}

/*---------------------------------------------------------------------------
 * deletes specified patient and associated records. returns true on success
 *---------------------------------------------------------------------------*/
+(BOOL)deletePatient: (NSString *)patientId
{
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
+(NSArray *)getPatientList
{
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

+(UIImage *)getPortraitFromServer:(NSString *)fileName
{
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
+(UIImage *)getThumbFromServer:(NSString *)fileName
{
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
+(NSArray *)getSurgeryList
{
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
 * description: queries database for current profile picture
 * returns UIImage of profile picture for specified patient
 *---------------------------------------------------------------------------*/
+(UIImage *)getProfilePictureFromServer:(NSString *)patientId
{
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
+(BOOL)sendPictureToServer:(UIImage *)picture
                  fileName:(NSString *)fileName
{
    
    NSData *imageData = UIImageJPEGRepresentation(picture, 90);
    // setting up the URL to post to
    NSString *urlString = [NSString stringWithFormat:@"%@add/addPicture",host];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----------------98761466499489749";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /*
	 now create the body of the post
     */
    NSString *contentDispoStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"rn", fileName];
    
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"rn--%@rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[contentDispoStr dataUsingEncoding:NSUTF8StringEncoding]]; //broken here
	[body appendData:[@"Content-Type: application/octet-streamrnrn" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"rn--%@--rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", returnString);
    return true;
}

/*---------------------------------------------------------------------------
 * You shouldn't need to call this directly; it gets called by addPicture
 * 
 *---------------------------------------------------------------------------*/
+(NSString *)addPicturePathToDatabase:(NSString *)pictureId: (NSString *)patientId:(NSString *)picturePath
                                     :(NSString *)pictureName: (NSString *)isProfile
{
    
    NSString *encodedString = [NSString stringWithFormat:@"%@add/addPicture/%@/%@/%@/%@/%@", host,
                               pictureId, patientId, picturePath, pictureName, isProfile];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        NSString *retval = [dic objectForKey:@"@returnValue"];
        NSLog(@"addPicture returned %@", retval);
        return retval;
    }
    NSLog(@"Error adding picturePath to Database");
    return NULL;
    
}

/*---------------------------------------------------------------------------
 * method concatenates patientId, the letter 'n', and the number of the
 * picture for the patient and returns a name.
 *---------------------------------------------------------------------------*/

+(NSString *) getNewPictureName:(NSString *)patientId
{
    NSString *numPicsURL = [NSString stringWithFormat:@"%@get/numPictures/%@", host, patientId];
    NSLog(@"numPicsURL: %@", numPicsURL);
    NSData *numPicsData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:numPicsURL]];
    if (!numPicsData)
        NSLog(@"Error retrieving numPics in method getNewPictureName");
    NSError *jsonError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:numPicsData options:kNilOptions error:&jsonError];
    NSDictionary *dic = jsonArray[0];
    int numPics = (int)[dic objectForKey:@"numPictures"];
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
+(NSString *) urlEncodeData:(NSString *)str
{
    NSString *encodedString = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)str,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUTF8);
    return encodedString;
}



@end

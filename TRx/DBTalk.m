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
//static NSString *portraitDir = nil;

+(void)initialize
{
    host = @"http://localhost:8888/TRxTalk/index.php/";
    //portraitDir = @"~/Google\ Drive/Team\ Ecuador/Data/images/portraits";
}


+(NSString *)addPatient:(NSString *)firstName
             middleName:(NSString *)middleName
               lastName:(NSString *)lastName
               birthday:(NSString *)birthday
{
    NSString *path = @"path";
    NSString *imageName = @"nameOfPicture";
    //NSString *url = [NSString stringWithFormat:@"%@TRxTalk/index.php/", host];
    NSString *encodedString = [NSString stringWithFormat:
                               @"%@add/addPatient/%@/%@/%@/%@/%@/%@", host,
                               firstName, middleName, lastName, birthday, path, imageName];
    
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

+(NSString *)addRecord:(NSString *)patientId
         surgeryTypeId:(NSString *)surgeryTypeId
{
    
    NSString *encodedString = [NSString stringWithFormat:@"%@add/addRecord/%@/%@/%@/%@/%@", host,
                               patientId, surgeryTypeId, @"1", @"1", @"0"];
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

+(NSString *)addPicture:(UIImage *)picture
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

/*
 *am hosting pictures on web.eecs.utk.edu/~jcotham/ecuador/TRx
 */
+(UIImage *)getPortraitFromServer:(NSString *)fileName
{
    NSString *str = [NSString stringWithFormat:@"http://web.eecs.utk.edu/~jcotham/ecuador/TRx/Data/images/%@.jpeg", fileName];
    NSURL *url = [NSURL URLWithString:str];
    UIImage *myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:url]];
    return myImage;
}

+(UIImage *)getThumbFromServer:(NSString *)fileName
{
    NSString *str = [NSString stringWithFormat:@"http://web.eecs.utk.edu/~jcotham/ecuador/TRx/Data/images/thumbs/%@.jpeg", fileName];
    NSURL *url = [NSURL URLWithString:str];
    UIImage *myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:url]];
    return myImage;
}

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
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"rn--%@rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"rn" dataUsingEncoding:NSUTF8StringEncoding]];
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

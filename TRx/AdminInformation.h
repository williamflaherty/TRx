//
//  AdminInformation.h
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdminInformation : NSObject

{
    NSArray *surgeryList;
    NSMutableArray *surgeryNamesList;
    NSArray *doctorList;
    NSMutableArray *doctorNamesList;
}

+(NSMutableArray *)getDoctorNames;
+(NSMutableArray *)getSurgeryNames;
+(NSString *) getSurgeryNameById:(NSString *)complaintId;
+(NSString *) getSurgeryIdByName:(NSString *)complaintName;



@end

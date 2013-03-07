//
//  AdminInformation.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "AdminInformation.h"
#import "DBTalk.h"

@implementation AdminInformation

+(NSMutableArray *)getDoctorNames
{
    NSArray *doctorList = [DBTalk getDoctorList];
    NSMutableArray *doctorNamesList = [[NSMutableArray alloc] init];
    
    if (doctorList != NULL) {
        for (NSDictionary *dic in doctorList) {
            NSString *lname = [dic objectForKey:@"LastName"];
            [doctorNamesList addObject:lname];
        }
        return doctorNamesList;
    }
    else {
        NSLog(@"Error retrieving doctorNamesList");
        return NULL;
    }
}

+(NSMutableArray *)getSurgeryNames
{
    NSArray *surgeryList = [DBTalk getSurgeryList];
    NSMutableArray *surgeryNamesList = [[NSMutableArray alloc] init];
    
    if (surgeryList != NULL) {
        for (NSDictionary *dic in surgeryList) {
            NSString *name = [dic objectForKey:@"Name"];
            [surgeryNamesList addObject:name];
        }
        return surgeryNamesList;
    }
    else {
        NSLog(@"Error retrieving surgeryNamesList");
        return NULL;
    }
}

@end

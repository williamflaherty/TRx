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

+(NSString *)getSurgeryNameById:(NSString *)complaintId {
    NSArray *surgeryList = [DBTalk getSurgeryList];
    if (surgeryList != NULL) {
        for (NSDictionary *dic in surgeryList) {
            NSString *tmp = [dic objectForKey:@"Id"];
            if([complaintId isEqualToString:tmp]){
                return [dic objectForKey:@"Name"];
            }
        }
    }
    else {
        NSLog(@"Error retrieving surgeryNamesList");
        return NULL;
    }
    return NULL; 
}

+(NSString *)getSurgeryIdByName:(NSString *)complaintName{
    NSArray *surgeryList = [DBTalk getSurgeryList];
    if (surgeryList != NULL) {
        for (NSDictionary *dic in surgeryList) {
            NSString *tmp = [dic objectForKey:@"Name"]; 
            if([complaintName isEqualToString:tmp]){
                return [dic objectForKey:@"Id"];
            }
        }
    }
    else {
        NSLog(@"Error retrieving surgeryNamesList");
        return NULL;
    }
    return NULL;

}

@end

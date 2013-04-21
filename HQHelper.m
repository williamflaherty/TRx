//
//  HQHelper.m
//  TRx
//
//  Created by Mark Bellott on 4/5/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HQHelper.h"

@implementation indexHelper
@synthesize questionId, nextYes, nextNo;

-(id) initWithID:(NSString*)q NextYes:(NSInteger)ny NextNo:(NSInteger)nn{
    self = [super init];
    if(self){
        self.questionId = q;
        self.nextYes = ny;
        self.nextNo = nn;
    }
    return self;
}

-(void) setQuestionID:(NSString*)q NextYes:(NSInteger)ny NextNo:(NSInteger)nn{
    self.questionId = q;
    self.nextYes = ny;
    self.nextNo = nn;
}

@end

@implementation HQHelper

@synthesize currentIndex, nextIndex, questionKeys;

-(id)init{
    if(self = [super init]){
        currentIndex = 0;
        nextIndex = 0;
        [self initializeQuestionTracker];
        
    }
    return self;
}

-(void)initializeQuestionTracker{
    indexHelper *tmp;
    questionTracker = [[NSMutableArray alloc]init];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_HowLong" NextYes:1 NextNo:1];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_PreventWorking" NextYes:1 NextNo:1];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_GettingWorse" NextYes:1 NextNo:1];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_HaveMedicalProblems" NextYes:2 NextNo:2];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_EverBeenInHospital" NextYes:1 NextNo:2];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_HaveEyeProblems" NextYes:1 NextNo:1];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_HearingTrouble" NextYes:1 NextNo:1];
    [questionTracker addObject:tmp];
    
    tmp = [[indexHelper alloc] initWithID:@"preOp_HaveHeartburnTroubleSwallowing" NextYes:1 NextNo:1];
    [questionTracker addObject:tmp];
}

-(NSInteger) getNextType{
    indexHelper* qKey = [questionTracker objectAtIndex:currentIndex];
    NSString *typeString = [Question getQuestionType:qKey.questionId];
    return [typeString integerValue];
}

-(NSString*) getNextEnglishLabel{
    indexHelper* qKey = [questionTracker objectAtIndex:currentIndex];
    return [Question getEnglishLabel:qKey.questionId];
}

-(NSString*) getNextTranslatedLabel{
    indexHelper* qKey = [questionTracker objectAtIndex:currentIndex];
    return [Question getTranslatedLabel:qKey.questionId];
}

-(NSMutableArray*) getOptions{
    
    //Dynamically generate this array from server...
    NSMutableArray *a = [[NSMutableArray alloc] initWithObjects:@"TB", @"AIDS", @"Hepititis", @"Pneumonia", @"Bronchitis", @"Other", nil];

    return a;
}

-(void) updateCurrentIndex{
    //Determine next index here...
    
    nextIndex = currentIndex + [[questionTracker objectAtIndex:currentIndex] nextYes];
    
    currentIndex = nextIndex;
}

-(void) updateCurrentIndexWithResponse:(NSMutableArray*)r{
    
    if([[r objectAtIndex:0] isEqual: @"YES"]){
        nextIndex = currentIndex + [[questionTracker objectAtIndex:currentIndex] nextYes];
    }
    else if ([[r objectAtIndex:0] isEqual:@"NO"]){
        nextIndex = currentIndex + [[questionTracker objectAtIndex:currentIndex] nextNo];
    }
    
    currentIndex = nextIndex;
    
}

@end

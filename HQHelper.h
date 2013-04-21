//
//  HQHelper.h
//  TRx
//
//  Created by Mark Bellott on 4/5/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//
// The Magic Data Structure class!!!

#import <Foundation/Foundation.h>
#import "Question.h"

@interface indexHelper : NSObject{
    NSString *questionId;
    NSInteger nextYes;
    NSInteger nextNo;
}

@property(nonatomic, retain) NSString *questionId;
@property(nonatomic, readwrite) NSInteger nextYes;
@property(nonatomic, readwrite) NSInteger nextNo;

@end

@interface HQHelper : NSObject{
    
    NSInteger currentIndex;
    NSInteger nextInedex;
    
    NSMutableArray *questionKeys;
    NSMutableArray *questionTracker;
 }

@property(nonatomic, readwrite) NSInteger currentIndex;
@property(nonatomic, readwrite) NSInteger nextIndex;
@property(nonatomic, retain) NSMutableArray *questionKeys;

-(void) initializeQuestionTracker;
-(NSInteger) getNextType;
-(NSString*) getNextEnglishLabel;
-(NSString*) getNextTranslatedLabel;
-(NSMutableArray*) getOptions;
-(void) updateCurrentIndex;
-(void) updateCurrentIndexWithResponse:(NSMutableArray*)r;

@end

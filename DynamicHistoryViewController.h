//
//  DynamicHistoryViewController.h
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "Question.h"
#import "HQHelper.h"
#import "HQView.h"

@interface DynamicHistoryViewController : UIViewController<UITextFieldDelegate>{
    
    float availableSpace;
    NSInteger pageCount;
    NSString *mainQuestionText;
    NSString *transQuestionText;
    
    HQHelper *qHelper;
    
    HQView *mainQuestion;
    HQView *transQuestion;
    
    
    //Arrays of Questions for main storage
    NSMutableArray *currentPage;
    NSMutableArray *previousPages;
    NSMutableArray *nextPages;
    NSMutableArray *answers;
    
    Boolean hasNextPages;
    
    IBOutlet UIButton *backButton, *nextButton;
    
}

//IBActions
-(IBAction)nextPressed:(id)sender;
-(IBAction)backPressed:(id)sender;

//Initial Methods
-(void) initialSetup;
-(void) initializeQueue;

//Question Handling Methods
-(void) loadNextQuestion;
-(void) loadPreviousQuestion;
-(void) dismissCurrentQuestion;
-(void) setPositionForMainQuestion:(HQView*)question;
-(void) setPositionForTransQuestion:(HQView*)question;

@end

//
//  DynamicHistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#define MAX_Y 50.0f
#define MID_Y 275.0f
#define MIN_Y 500.0f
#define ENG_X 50.0f
#define TRANS_X 550.0f

#import "DynamicHistoryViewController.h"

@interface DynamicHistoryViewController ()

@end

@implementation DynamicHistoryViewController

#pragma mark - IBAction Methods

-(IBAction)backPressed:(id)sender{
    if(pageCount == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self loadPreviousQuestion];
        pageCount--;
    }
}

-(IBAction)nextPressed:(id)sender{
    pageCount++;
    [self loadNextQuestion];
}

#pragma mark - Init Methods

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) initialSetup{
    
    hasNextPages = NO;
    
    pageCount = 1;
    availableSpace = MAX_Y - MIN_Y; 
    
    mainQuestion = [[HQView alloc]init];
    transQuestion = [[HQView alloc]init];
    
    previousPages = [[NSMutableArray alloc] init];
    nextPages = [[NSMutableArray alloc]init];
    answers = [[NSMutableArray alloc] init];
    
    [self initializeQueue];
    [self loadNextQuestion];
}

#pragma mark - Question Loading Methods

-(void) initializeQueue{
    qHelper = [[HQHelper alloc] init];
}

-(void) loadNextQuestion{
    //Load Question from the Queue, Hard coded for now...
    
   
    if(pageCount != 1){
        [mainQuestion checkHasAnswer];
        
        if(!mainQuestion.hasAnswer){
            UIAlertView *provideAnswer = [[UIAlertView alloc] initWithTitle:@"Wait!" message:@"Please provide an answer before continuing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [provideAnswer show];
            return;
        }
        
        [previousPages addObject:mainQuestion];
        [previousPages addObject:transQuestion];
        [self findAnswers];
        [qHelper updateCurrentIndexWithResponse:answers];
        //[qHelper updateCurrentIndex];
    }
    
    if(hasNextPages){
        [self dismissCurrentQuestion];
        
        transQuestion = [nextPages lastObject];
        [nextPages removeLastObject];
        [self .view addSubview:transQuestion];
        
        mainQuestion = [nextPages lastObject];
        [nextPages removeLastObject];
        [self.view addSubview:mainQuestion];
        
        if([nextPages lastObject] == NULL)  hasNextPages = NO;
        
        return;
    }
    
    HQView *newMainQuestion = [[HQView alloc] init];
    HQView *newTransQuestion = [[HQView alloc] init];
    
    if(pageCount != 1){
        [self dismissCurrentQuestion];
    }
    
    newMainQuestion.type = [qHelper getNextType];
    [newMainQuestion setQuestionLabelText:[qHelper getNextEnglishLabel]];
    
    newTransQuestion.type = [qHelper getNextType];
    [newTransQuestion setQuestionLabelText:[qHelper getNextTranslatedLabel]];
    
    //[qHelper updateCurrentIndex];

    [newMainQuestion buildQuestionOfType:newMainQuestion.type withHelper:qHelper];
    [self setPositionForMainQuestion:newMainQuestion];
    
    [newTransQuestion buildQuestionOfType:newTransQuestion.type withHelper:qHelper];
    [self setPositionForTransQuestion:newTransQuestion];
    
    if(newMainQuestion.type == TEXT_ENTRY){
        newMainQuestion.textEntryField.delegate = self;
        newTransQuestion.textEntryField.delegate = self;
    }
    
    newMainQuestion.connectedView = newTransQuestion;
    newTransQuestion.connectedView = newMainQuestion;
    
    mainQuestion = newMainQuestion;
    transQuestion = newTransQuestion;
    
    [self.view addSubview:mainQuestion];
    [self.view addSubview:transQuestion];
    
    [answers removeAllObjects];
}

-(void) loadPreviousQuestion{
    if(pageCount == 1){
        return;
    }
    
    hasNextPages = YES;
    [nextPages addObject:mainQuestion];
    [nextPages addObject:transQuestion];
    
    [self dismissCurrentQuestion];
    
    transQuestion = [previousPages lastObject];
    [previousPages removeLastObject];
    [self.view addSubview:transQuestion];
    
    mainQuestion = [previousPages lastObject];
    [previousPages removeLastObject];
    [self.view addSubview:mainQuestion];
    
}

-(void) dismissCurrentQuestion{
    [mainQuestion removeFromSuperview];
    [transQuestion removeFromSuperview];
}

-(void) setPositionForMainQuestion:(HQView *)q{
    float yPos = MID_Y - (q.frame.size.height/2);
    q.frame = CGRectMake(ENG_X, yPos, q.frame.size.width, q.frame.size.height);
}

-(void) setPositionForTransQuestion:(HQView *)q{
    float yPos = MID_Y - (q.frame.size.height/2);
    q.frame = CGRectMake(TRANS_X, yPos, q.frame.size.width, q.frame.size.height);
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(mainQuestion.type == TEXT_ENTRY){
        [mainQuestion.textEntryField resignFirstResponder];
        [transQuestion.textEntryField resignFirstResponder];
    }
    else if(mainQuestion.type == MULTIPLE_SELECTION){
        for(HQTextField *tf in mainQuestion.selectionTextFields){
            [tf resignFirstResponder];
        }
        for(HQTextField *tf in transQuestion.selectionTextFields){
            [tf resignFirstResponder];
        }
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if(textField == mainQuestion.textEntryField){
        transQuestion.textEntryField.text = mainQuestion.textEntryField.text;
    }
    if(textField == transQuestion.textEntryField){
        mainQuestion.textEntryField.text = transQuestion.textEntryField.text;
    }
}

-(void) findAnswers{
    [answers removeAllObjects];
    
    if(mainQuestion.type == TEXT_ENTRY){
        [answers addObject:@"YES"];
        [answers addObject:mainQuestion.textEntryField.text];
    }
    
    else if (mainQuestion.type == YES_NO){
        if(mainQuestion.yesButton.selected){
            [answers addObject:@"YES"];
        }
        else{
            [answers addObject:@"NO"];
        }
    }
    
    else if (mainQuestion.type == MULTIPLE_SELECTION){
        [answers addObject:@"YES"];
        for(HQCheckBox *cb in mainQuestion.checkBoxes){
            if(cb.selected){
                [answers addObject:cb.optionLabel];
            }
        }
    }
    
//    NSString *answerString = [answers componentsJoinedByString:@", "]; 
//    NSArray *previousAnswers = [answerString componentsSeparatedByString:@", "];
    
}

@end

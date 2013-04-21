//
//  HQView.h
//  TRx
//
//  Created by Mark Bellott on 4/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQCheckBox.h"
#import "HQHelper.h"
#import "HQLabel.h"
#import "HQSelector.h"
#import "HQTextField.h"
#import "HQYesNo.h"
#import "HQHelper.h"

typedef enum{
    YES_NO,
    SELECTION_LIKE,
    MULTIPLE_SELECTION,
    TEXT_ENTRY
}qType;

@interface HQView : UIView <UITextFieldDelegate>{
    
    BOOL hasAnswer;
    
    float totalHeight;
    float responseHeight;
    
    NSString *responseString;
    NSString *previousTextEntry;
    
    
    qType type;
    HQLabel *questionLabel;
    HQSelector *yesNoSelector;
    HQYesNo *yesButton;
    HQYesNo *noButton;
    HQTextField *textEntryField;
    
    NSMutableArray *response;
    NSMutableArray *checkBoxes;
    NSMutableArray *selectionTextFields;
    NSMutableArray *questionUnion;
    
    HQView *connectedView;
}

@property(nonatomic, readwrite) BOOL hasAnswer;
@property(nonatomic, readwrite) qType type;
@property(nonatomic, readwrite) HQLabel* questionLabel;
@property(nonatomic, retain) HQTextField *textEntryField;
@property(nonatomic, retain) HQSelector *yesNoSelector;
@property(nonatomic, retain) HQYesNo *yesButton;
@property(nonatomic, retain) HQYesNo *noButton;
@property(nonatomic, retain) NSString *previousTextEntry;
@property(nonatomic, retain) NSString *responseString;
@property(nonatomic, retain) NSMutableArray *checkBoxes;
@property(nonatomic, retain) NSMutableArray *selectionTextFields;
@property(nonatomic, retain) HQView *connectedView;

-(void) checkHasAnswer;
-(void) setQuestionLabelText:(NSString *)text;
-(void) buildQuestionOfType:(NSInteger)t withHelper:(HQHelper*)h;
-(void) buildYesNo;
-(void) buildSingleSelection;
-(void) buildMultipleSelectionWithOptions:(NSMutableArray*)options;
-(void) buildTextEntry;

@end
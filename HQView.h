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

typedef enum{
    YES_NO,
    SINGLE_SELECTION,
    MULTIPLE_SELECTION,
    TEXT_ENTRY
}qType;

@interface HQView : UIView <UITextFieldDelegate>{
    
    float totalHeight;
    float responseHeight;
    
    NSString *responseString;
    
    qType type;
    HQLabel *questionLabel;
    HQSelector *yesNoSelector;
    HQTextField *textEntryField;
    
    NSMutableArray *response;
    NSMutableArray *questionUnion;
}

@property(nonatomic, readwrite) qType type;
@property(nonatomic, readwrite) HQLabel* questionLabel;

-(void) setQuestionLabelText:(NSString *)text;
-(void) buildQuestionOfType:(NSInteger)t;
-(void) buildYesNo;
-(void) buildSingleSelection;
-(void) buildMultipleSelection;
-(void) buildTextEntry;

@end

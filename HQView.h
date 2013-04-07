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

@interface HQView : UIView{
    
    float totalHeight;
    
    qType type;
    
    HQLabel *questionLabel;
    HQSelector *yesNoSelector;
    
    NSMutableArray *response;
    NSMutableArray *questionUnion;
}

@property(nonatomic, readwrite) HQLabel* questionLabel;

-(void)setQuestionLabelText:(NSString *)text;

@end

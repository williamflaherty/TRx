//
//  HQView.m
//  TRx
//
//  Created by Mark Bellott on 4/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HQView.h"

#define FONT_SIZE 20

#define Y_PADDING 20.0f

#define MAX_Y 50.0f
#define MIN_Y 500.0f
#define ENG_X 50.0f
#define TRANS_X 550.0f
#define SELECT_OFFSET 50.0f

#define CONST_WIDTH 425.0f
#define SELECT_WIDTH 375.0f

@implementation HQView

@synthesize questionLabel, type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 100, 100);
        
        totalHeight = 0;
        responseHeight = 0;
        
        response = [[NSMutableArray alloc]init];
        questionUnion = [[NSMutableArray alloc]init];
        
        questionLabel = [[HQLabel alloc] init];
        [questionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
        [questionLabel setTextColor:[UIColor blackColor]];
        [questionUnion addObject:questionLabel];
        [self addSubview:questionLabel];
        
        
    }
    return self;
}

-(void) setQuestionLabelText:(NSString *)text{
    questionLabel.text = text;
}

-(void) buildQuestionOfType:(NSInteger)t{
    if(t==0){
        type = YES_NO;
        [self buildYesNo];
    }
    else if(t==1){
        type = SINGLE_SELECTION;
        [self buildSingleSelection];
    }
    else if(t==2){
        type = MULTIPLE_SELECTION;
        [self buildMultipleSelection];
    }
    else if(t==3){
        type = TEXT_ENTRY;
        [self buildTextEntry];
    }
    else{
        NSLog(@"Error: Invalid Question Type Encountered.");
    }
}

-(void) buildYesNo{
    
    yesNoSelector = [[HQSelector alloc] initWithItems:[NSArray arrayWithObjects:@"Yes", @"No", nil]];
    yesNoSelector.segmentedControlStyle = UISegmentedControlStyleBordered;
    yesNoSelector.frame = CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y + Y_PADDING + questionLabel.frame.size.height, yesNoSelector.frame.size.width, yesNoSelector.frame.size.height);
    
    responseHeight = yesNoSelector.frame.size.height;
    
    [response addObject:yesNoSelector];
    
    [self addSubview:yesNoSelector];
    
    [self adjustFrame];
    
}

-(void) buildSingleSelection{
    
}

//Come back for restructuring...
//NEED: Pairs? All inside of HQCheckBox? Multiple Arrays (For the Labels and Buttons, or all in one class).
//All one class option is BETTER!
-(void) buildMultipleSelection{
    
    NSInteger count = 0;
    NSMutableArray *options = [[NSMutableArray alloc] initWithObjects:@"TB", @"AIDS", @"Hepititis", @"Pneumonia", @"Bronchitis", @"Other", nil];
    NSMutableArray *tmpButtons = [[NSMutableArray alloc] init];
    
    for(NSString *s in options){
        HQLabel *tmp = [[HQLabel alloc]init];
        HQLabel *lastLabel = [[HQLabel alloc]init];
        HQCheckBox *box = [[HQCheckBox alloc]init];
        HQCheckBox *lastBox = [[HQCheckBox alloc]init];
        
        tmp.constrainedWidth = 375;
        [tmp setText:s];
        
        if(count == 0){
            tmp.frame = CGRectMake(questionLabel.frame.origin.x + SELECT_OFFSET, questionLabel.frame.origin.y + questionLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
            box.frame = CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y + questionLabel.frame.size.height + Y_PADDING, 30, 30);
        }
        else{
            lastLabel = [response lastObject];
            lastBox = [tmpButtons lastObject];
            tmp.frame = CGRectMake(lastLabel.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, tmp.frame.size.width, tmp.frame.size.height);
            box.frame = CGRectMake(lastBox.frame.origin.x, lastLabel.frame.origin.y + lastLabel.frame.size.height + Y_PADDING, 30, 30);
        }
        
        responseHeight += tmp.frame.size.height;
        
        [response addObject: tmp];
        [tmpButtons addObject:box];
        [questionUnion addObject:tmp];
        [questionUnion addObject:box];
    
        [self addSubview:tmp];
        [self addSubview:box];
        
        count++;
    }
    
    [self adjustFrame];
    
}

-(void) buildTextEntry{
    
    textEntryField = [[HQTextField alloc] init];
    textEntryField.borderStyle = UITextBorderStyleBezel;
    textEntryField.keyboardType = UIKeyboardTypeDefault;
    textEntryField.autocorrectionType = UITextAutocorrectionTypeNo;
    textEntryField.delegate = textEntryField.self;
    
    [textEntryField setFont:[UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]];
    textEntryField.frame = CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y + questionLabel.frame.size.height + Y_PADDING, CONST_WIDTH, 40);
    
    responseHeight = textEntryField.frame.size.height;
    
    [response addObject:textEntryField];
    [questionUnion addObject:textEntryField];
    
    [self addSubview:textEntryField];
    
    [self adjustFrame];
    
}

-(void) adjustFrame{
    float tmpHeight = 0;
    
    tmpHeight += questionLabel.frame.size.height;
    tmpHeight += Y_PADDING;
    tmpHeight += responseHeight;
    
    [self setFrame:CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y, self.frame.size.width, tmpHeight)];
    
    totalHeight += tmpHeight;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  HQView.m
//  TRx
//
//  Created by Mark Bellott on 4/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HQView.h"

#define Y_PADDING 20.0f
#define MAX_Y 50.0f
#define MIN_Y 500.0f
#define ENG_X 50.0f
#define TRANS_X 550.0f
#define CONST_WIDTH 425.0f

@implementation HQView

@synthesize questionLabel, type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 100, 100);
        
        totalHeight = 0;
        response = [[NSMutableArray alloc]init];
        questionUnion = [[NSMutableArray alloc]init];
        
        questionLabel = [[HQLabel alloc] init];
        [questionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        [questionLabel setTextColor:[UIColor blackColor]];
        [questionUnion addObject:questionLabel];
        [self addSubview:questionLabel];
        
    }
    return self;
}

-(void) setQuestionLabelText:(NSString *)text{
    questionLabel.text = text;
}

-(void) setResponse{
    if(type == YES_NO){
        
        yesNoSelector = [[HQSelector alloc] initWithItems:[NSArray arrayWithObjects:@"Yes", @"No", nil]];
        yesNoSelector.segmentedControlStyle = UISegmentedControlStyleBordered;
        yesNoSelector.frame = CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y + Y_PADDING + questionLabel.frame.size.height, yesNoSelector.frame.size.width, yesNoSelector.frame.size.height);
        
        [self addSubview:yesNoSelector];
        
        [self setFrame: CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y, self.frame.size.width, (questionLabel.frame.size.height + Y_PADDING + yesNoSelector.frame.size.height))];
        
    }
}

-(void) adjustFrame{
    float tmpHeight = 0;
    
    tmpHeight += questionLabel.frame.size.height;
    tmpHeight += Y_PADDING;
    tmpHeight += yesNoSelector.frame.size.height;
    
    [self setFrame:CGRectMake(questionLabel.frame.origin.x, questionLabel.frame.origin.y, self.frame.size.width,tmpHeight)];
    
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

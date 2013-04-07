//
//  HQView.m
//  TRx
//
//  Created by Mark Bellott on 4/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HQView.h"

@implementation HQView

@synthesize questionLabel;

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
        
        if(type == YES_NO){
            
            
        }
        
    }
    return self;
}

-(void) setQuestionLabelText:(NSString *)text{
    questionLabel.text = text;
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

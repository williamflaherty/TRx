//
//  HistoryQuestionLabel.m
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#define MIN_HEIGHT 10.0f

#import "HistoryQuestionLabel.h"

@implementation HistoryQuestionLabel

@synthesize minHeight;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minHeight = MIN_HEIGHT;
    }
    return self;
}

-(void)calculateSize{
    CGSize constraint = CGSizeMake(self.frame.size.width/2, 20000.0f);
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self setAdjustsFontSizeToFitWidth:NO];
    [self setNumberOfLines:0];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, MAX(size.height, MIN_HEIGHT))];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self calculateSize];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self calculateSize];
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

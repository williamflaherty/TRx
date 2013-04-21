//
//  HQYesNo.m
//  TRx
//
//  Created by Mark Bellott on 4/15/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HQYesNo.h"

@implementation HQYesNo

@synthesize hasChanged;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        hasChanged = NO;
    }
    return self;
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

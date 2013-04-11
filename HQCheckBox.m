//
//  HQCheckBox.m
//  TRx
//
//  Created by Mark Bellott on 4/5/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HQCheckBox.h"

@implementation HQCheckBox

@synthesize toggleCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        toggleCount = 0;
        
        self.frame = CGRectMake(0, 0, 20, 20);
        self = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addTarget:self action:@selector(checkPressed)forControlEvents:UIControlEventTouchUpInside];  
    }
    return self;
}



-(void) checkPressed{
    if(toggleCount == 0){
        self.backgroundColor = [UIColor blueColor];
        toggleCount++;
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
        toggleCount--;
    }
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

//
//  HQLabel.m
//  TRx
//
//  Created by Mark Bellott on 4/5/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#define MIN_HEIGHT 10.0f
#define CONST_WIDTH 425.0f


#import "HQLabel.h"

@implementation HQLabel

@synthesize minHeight, constrainedWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        constrainedWidth = 0;
        
        self.minHeight = MIN_HEIGHT;
        self.frame = CGRectMake(0, 0, CONST_WIDTH, 100);
        
        [self setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        [self setTextColor:[UIColor blackColor]];
        
        self.backgroundColor = [UIColor colorWithRed:200 green:200 blue:150 alpha:0];
        
    }
    return self;
}

-(void)calculateSize{

    CGSize constraint;
    
    if(constrainedWidth == 0){
        constraint = CGSizeMake(CONST_WIDTH, 20000.0f);
    }
    else{
        self.frame = CGRectMake(0, 0, constrainedWidth, 100);
        constraint = CGSizeMake(constrainedWidth, 20000.0f);
    }
    
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self setAdjustsFontSizeToFitWidth:NO];
    [self setNumberOfLines:0];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height)];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self calculateSize];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self calculateSize];
}

//Blurred shadow behind text
- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    float colorValues[] = {0, 0, 0, .4};
    CGColorRef shadowColor = CGColorCreate(colorSpace, colorValues);
    CGSize shadowOffset = CGSizeMake(0, 0);
    CGContextSetShadowWithColor (context, shadowOffset, 4 /* blur */, shadowColor);
    [super drawTextInRect:rect];
    
    CGColorRelease(shadowColor);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
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

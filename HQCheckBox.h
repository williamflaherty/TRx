//
//  HQCheckBox.h
//  TRx
//
//  Created by Mark Bellott on 4/5/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQCheckBox : UIButton{
    NSInteger toggleCount;
    NSString *optionLabel;
    NSInteger arrayIndex;
}

@property(nonatomic, readonly) NSInteger toggleCount;
@property(nonatomic, retain) NSString *optionLabel;
@property(nonatomic, readwrite) NSInteger arrayIndex;

-(void) checkPressed;

@end

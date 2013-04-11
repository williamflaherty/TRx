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
}

@property(nonatomic,readonly) NSInteger toggleCount;

-(void) checkPressed;

@end

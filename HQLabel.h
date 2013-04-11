//
//  HQLabel.h
//  TRx
//
//  Created by Mark Bellott on 4/5/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQLabel : UILabel{

    float minHeight;
    float constrainedWidth;

}

@property(nonatomic) float minHeight;
@property(nonatomic, readwrite) float constrainedWidth;

-(void) calculateSize;

@end
//
//  HistoryQuestionLabel.h
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryQuestionLabel : UILabel{
    
    float minHeight;
    
}

@property (nonatomic) float minHeight;

-(void) calculateSize;

@end

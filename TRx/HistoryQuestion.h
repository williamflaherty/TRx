//
//  HistoryQuestion.h
//  TRx
//
//  Created by Mark Bellott on 3/19/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    YESNO,
    SINGLESELECTION,
    MULTIPLESELECTION,
    TEXTFIELD,
    OTHER,
} qType;

@interface HistoryQuestion : UIImageView{
    
    qType type;
    float minHeight, maxHeight;
    UIImage *backgroundImage;
    
    NSString *qEnglish, *qSpanish;
    
    
    
}

@end

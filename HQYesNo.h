//
//  HQYesNo.h
//  TRx
//
//  Created by Mark Bellott on 4/15/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQYesNo : UIButton{
    BOOL hasChanged;
}

@property(nonatomic,readwrite)BOOL hasChanged;

@end

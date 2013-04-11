//
//  PACUViewController.h
//  TRx
//
//  Created by Mark Bellott on 3/9/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PACUViewController : UIViewController{
    
    __weak IBOutlet UILabel *patientName;
    __weak IBOutlet UILabel *patientSurgery;
    __weak IBOutlet UIImageView *patientThumbnail;
}

@end

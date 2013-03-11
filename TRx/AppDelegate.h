//
//  AppDelegate.h
//  TRx
//
//  Created by Mark Bellott on 2/17/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *databasePath;

-(void) createAndCheckDatabase;

@end

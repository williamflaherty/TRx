//
//  SurgeryViewController.h
//  TRx
//
//  Created by Dwayne Flaherty on 3/12/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SurgeryViewController : UIViewController <UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *filesTable;

}
@property BOOL newMedia;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *saveRecording;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)recordAudio:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)pauseRecording:(id)sender;
- (IBAction)saveRecord:(id)sender;
- (IBAction)useCamera:(id)sender;
@end

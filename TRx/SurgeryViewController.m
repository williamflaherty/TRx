//
//  SurgeryViewController.m
//  TRx
//
//  Created by Dwayne Flaherty on 3/12/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "SurgeryViewController.h"
#import "localtalk.h"


@interface SurgeryViewController ()

@end

@implementation SurgeryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)newRecording {
    
    _playButton.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *calendarDate = [now description];
    
    NSString *audioFilePath = [NSString stringWithFormat:@"%@/%@.caf", docsDir, calendarDate];
    
    soundFileURL = [NSURL fileURLWithPath:audioFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
//  fileNameText.text = now;
}

#pragma mark - audio recording button methods 
- (IBAction)recordAudio:(id)sender {
    
    /*if not recording */ 
    if (!_audioRecorder.recording)
    {
        if(isPaused){ //start recording again
            _playButton.enabled = NO;
            isPaused = NO; 
            /*IMPLEMENT: call method to change button to pause button*/ 
            [_audioRecorder record];
        } else {
            //initialize a new file and start recording
            [self newRecording];
            /*IMPLEMENT: call method to change button to pause button*/ 
            [_audioRecorder record]; 
        }
        /*if it is recording just pause it*/ 
    } else if(_audioRecorder.recording) {
        /*IMPLEMENT: call method to change the button to record*/
        isPaused = YES; 
        [_audioRecorder pause]; 
    }
}

- (IBAction)playAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        _recordButton.enabled = NO;
        
        NSError *error;
        
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:_audioRecorder.url
                        error:&error];
        
        _audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [_audioPlayer play];
    }
}

- (IBAction)saveRecord:(id)sender{
    [_audioRecorder stop];
    NSError *error;
    NSData *audioData = [NSData dataWithContentsOfFile:[soundFileURL path] options: 0 error:&error];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:now];
        BOOL check = [LocalTalk localStoreAudio:audioData fileName: stringFromDate];        
        if(!check){
            //the file didn't store so do something here broke do something :( 
        }
    }
    _playButton.enabled = YES; 
}

#pragma mark - audio recording delegate methods
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _recordButton.enabled = YES;
  //  _stopButton.enabled = NO;
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

#pragma mark - user camera method
- (void) useCamera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
    }
}

#pragma mark - UIImagePickerControllerDelegate
/*
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Store the image for the patient
    
   // photoID = finalImage;
   // newPatient.photoID = finalImage;
    
    //Display the final image
    //_imageView.image = finalImage;
    
}*/


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* static NSString *CellIdentifier = @"patientListCell";
    PatientListViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier
                                 forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    NSString *fn = [[patients objectAtIndex:row] firstName];
    NSString *mn = [[patients objectAtIndex:row] middleName];
    NSString *ln = [[patients objectAtIndex:row] lastName];
    NSString *name = [NSString stringWithFormat: @"%@ %@ %@", fn, mn, ln];
    cell.patientName.text = name;
    cell.chiefComplaint.text = (NSString*)[[patients objectAtIndex:row] chiefComplaint];
    cell.patientPicture.image = [[patients objectAtIndex:row] photoID];
    //cell.patientPicture.image = [UIImage imageNamed:_carImages[row]];
    
    return cell;*/
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

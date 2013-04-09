//
//  PatientListViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "PatientListViewController.h"
#import "PatientListViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DBTalk.h" 
#import "LocalTalk.h"
#import "Patient.h"

/*
    NOTE:
    I added a Refresh button to the top of the patient list in story board. I think it would be a nice option.
    Reming me to talk about it...
*/


@interface PatientListViewController ()

@end

@implementation PatientListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Adding patient segues to 2nd tab 

-(void)addPatients:(id)sender{
    /* clear local database for new patient */
    [LocalTalk localClearPatientData];
    
    /* initialize local database with temp values for patientId and recordId */
    [LocalTalk localStoreTempPatientId];
    [LocalTalk localStoreTempRecordId];
    [self performSegueWithIdentifier:@"listTabSegue" sender:addPatientsButton];
}

/*Function to refresh patients list, we need to make this async and to disable the refreshButton button until it's done*/ 
-(void)refreshPatients:(id)sender{
    patients = [LocalTalk localGetPatientList];    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITabBarController *vc;
    if (([[segue identifier] isEqualToString:@"listTabSegue"]) && ([sender tag] == 1)){
        vc = [segue destinationViewController];
        vc.selectedIndex=1;
    } else {
        vc = [segue destinationViewController];
        //PatientListViewCell *mycell = (PatientListViewCell*)sender;
        vc.selectedIndex=0;
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //patients = [LocalTalk localGetPatientList];
  
    //[PatientListViewCell class];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (unsigned long) patients.count;
}

/*---------------------------------------------------------------------------
 Summary:
    Loads cells for tableview.
    thumbnails now load asynchronously
 Details:
    redeclared cells to be __unsafe_unretained
 TODO:
    can I encapsulate this code in DBTalk's getThumb?
    can these images be stored in an array so they don't always have to be loaded from server?
    clean up
 *---------------------------------------------------------------------------*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name;
    
    static NSString *CellIdentifier = @"patientListCell";
    __unsafe_unretained PatientListViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    NSString *fn = [[patients objectAtIndex:row] firstName];
    NSString *mn = [[patients objectAtIndex:row] middleName]; 
    NSString *ln = [[patients objectAtIndex:row] lastName];
    NSURL *url = [[patients objectAtIndex:row] photoURL];
   // if(){
      //  name = [NSString stringWithFormat: @"%@ %@", fn, ln];
    //} else {
    name = [NSString stringWithFormat: @"%@ %@ %@", fn, mn, ln]; 

    cell.patientName.text = name;
    cell.chiefComplaint.text = (NSString*)[[patients objectAtIndex:row] chiefComplaint];
  
 
    [cell.patientPicture setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:NULL success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"success");
      cell.patientPicture.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"fail");
  }];
    
    return cell;
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

@end

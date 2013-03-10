//
//  PatientListViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "PatientListViewController.h"
#import "PatientListViewCell.h"
#import "DBTalk.h" 
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[PatientListViewCell class];
    NSString *firstName, *lastName, *patientId, *imageId, *complaint, *middleName;
    UIImage *picture;
    _patientsArray = [DBTalk getPatientList];
    _patients = [NSMutableArray array];
    NSArray *complaints = [NSArray arrayWithObjects:@"Cleft Lip",@"Hernia",@"Cataracts", nil];
    
    for(NSDictionary *item in _patientsArray){
        NSLog(@"%@", item);
        firstName = [item objectForKey:@"FirstName"];
        middleName = [item objectForKey:@"MiddleName"];
        lastName = [item objectForKey:@"LastName"];
        patientId = [item objectForKey:@"Id"];
        imageId = [NSString stringWithFormat:@"%@n000", patientId];
        picture = [DBTalk getThumbFromServer:(imageId)];
        uint32_t rnd = arc4random_uniform([complaints count]);
        complaint = [complaints objectAtIndex:rnd];
        Patient *obj = [[Patient alloc] initWithFirstName:(firstName) MiddleName:(middleName) LastName:(lastName) ChiefComplaint:(complaint) PhotoID:(picture)];
        NSLog(@"%@", picture);
        NSLog(@"%@", imageId);
        [_patients addObject:obj];
    }
    
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
    return (unsigned long)_patientsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"patientListCell";
    PatientListViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier
                              forIndexPath:indexPath];
    
    // Configure the cell...
    
    int row = [indexPath row];
    NSString *fn = [[_patients objectAtIndex:row] firstName];
    NSString *mn = [[_patients objectAtIndex:row] middleName];
    NSString *ln = [[_patients objectAtIndex:row] lastName];
    NSString *name = [NSString stringWithFormat: @"%@ %@ %@", fn, mn, ln];
    cell.patientName.text = name;
    cell.chiefComplaint.text = [[_patients objectAtIndex:row] chiefComplaint];
    cell.patientPicture.image = [[_patients objectAtIndex:row] photoID];
    //cell.patientPicture.image = [UIImage imageNamed:_carImages[row]];
    
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

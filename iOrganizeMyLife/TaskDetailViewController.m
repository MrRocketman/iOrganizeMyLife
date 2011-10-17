//
//  TaskDetailViewController.m
//  iOrganize My Life
//
//  Created by James Adams on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "iOrganize_My_LifeAppDelegate.h"

@implementation TaskDetailViewController

@synthesize data, task, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) 
    {
        // Custom initialization
        self.data = [(iOrganize_My_LifeAppDelegate *)[[UIApplication sharedApplication] delegate] data];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Editing";
    
    [textField setText:[data titleForTask:task]];
    [textField setFont:[UIFont systemFontOfSize:17.0]];
    [textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [data setTitle:[textField text] forTask:task];
    [textField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(section == TASK_TITLE_SECTION)
    {
        return TASK_TITLE_NUMBER_OF_ROWS;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == TASK_TITLE_SECTION)
    {
        return @"Title";
    }
    
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    if([indexPath section] == TASK_TITLE_SECTION)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}


// Customize the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if([indexPath section] == TASK_TITLE_SECTION)
    {
        static NSString *CellIdentifier = @"TextFieldCell";
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = tableViewTextFieldCell;
            //cell = [tableViewTextFieldCell copy];
            //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

// Override to support editing the table view.
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
}*/

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

// Override to support conditional rearranging of the table view.
/*- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}*/

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    //NSLog(@"selected row:%d", [indexPath row]);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [data setTitle:[textField text] forTask:task];
    [textField resignFirstResponder];
    
    return NO;
}

@end

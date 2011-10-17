//
//  FirstViewController.m
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OrganizerMovingViewController.h"
#import "iOrganizeMyLifeAppDelegate.h"
#import "TaskDetailViewController.h"


@interface OrganizerMovingViewController()

- (void)cancel:(id)sender;
- (void)move:(id)sender;

@end


@implementation OrganizerMovingViewController

@synthesize tableView, data, task, selectedTasks, parentTask, delegate;

#pragma mark - ViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) 
    {
        // Custom initialization
        [self setData:[(iOrganizeMyLifeAppDelegate *)[[UIApplication sharedApplication] delegate] data]];
        [self setTask:[self.data rootTask]];
    }
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!self.task)
    {
        [self setData:[(iOrganizeMyLifeAppDelegate *)[[UIApplication sharedApplication] delegate] data]];
        [self setTask:[self.data rootTask]];
    }
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithTitle:@"Move Here" style:UIBarButtonItemStyleDone target:self action:@selector(move:)];
    [toolbar setItems:[NSArray arrayWithObject:moveButton]];
    [moveButton release];
    
    self.navigationItem.title = [data titleForTask:self.task];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Private Methods

- (void)cancel:(id)sender
{
    [delegate didCancel];
}

- (void)move:(id)sender
{
    // Sort the selected tasks, otherwise moving them will cause major issues (indexes get all messed up)
    // Bubble sort
    int maxValue = [selectedTasks count] - 1;
    BOOL isSorted = NO;
    
    while(!isSorted)
    {
        isSorted = YES;
        
        for(int i = 0; i < maxValue; i ++)
        {
            if([[selectedTasks objectAtIndex:i] row] > [[selectedTasks objectAtIndex:i + 1] row])
            {
                [selectedTasks exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                
                isSorted = NO;
            }
            
            if(i == maxValue - 1)
            {
                maxValue --;
            }
        }
    }
    
    // Move each of the tasks recursively
    for(int i = [selectedTasks count] - 1; i >= 0; i --)
    {
        // The 'toIndex' has to be a constant. Because the objects need to be deleted by largest index first and inserted by smallest index first. Or First in, Last out. Using a constant for 'toInex' accomplishes the task simply.
        [data moveSubtaskAtIndex:[[selectedTasks objectAtIndex:i] row] forTask:parentTask toIndex:0 forTask:task];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidFinishMovingWithTargetTask" object:nil userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:task, selectedTasks, nil] forKeys:[NSArray arrayWithObjects:@"task", @"selectedTasks", nil]]];
    [delegate didFinishMoving];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    //NSLog(@"subtask count %d", [data subtaskCountForTask:task]);
    return [data subtaskCountForTask:task] + [selectedTasks count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    NSMutableDictionary *subtask;
    
    // Show the tasks that are moving
    if([indexPath row] < [selectedTasks count])
    {
        subtask = [self.data subtaskAtIndex:[[selectedTasks objectAtIndex:[indexPath row]] row] forTask:parentTask];
        //subtask = [selectedTasks objectAtIndex:[indexPath row]];
        [cell setBackgroundColor:[UIColor blueColor]];
    }
    // Show the normal tasks
    else
    {
        subtask = [data subtaskAtIndex:[indexPath row] - [selectedTasks count] forTask:task];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    // Show the tasks text
    [[cell textLabel] setText:[data titleForTask:subtask]];
    
    // TODO: Show the priority
    if([data subtaskCountForTask:[data subtaskAtIndex:[indexPath row] - [selectedTasks count] forTask:task]] < 1)
    {
        [[cell imageView] setImage:[UIImage imageNamed:@"GreenCircle.png"]];
    }
    else
    {
        [[cell imageView] setImage:[UIImage imageNamed:@"GreenCircleGreenDetail.png"]];
    }
}


// Customize the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"OrgainzerCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    //NSLog(@"selected row:%d", [indexPath row]);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrganizerMovingViewController *viewController = [[OrganizerMovingViewController alloc] initWithNibName:@"OrganizerMovingView" bundle:nil];
    [viewController setTask:[data subtaskAtIndex:[indexPath row] - [selectedTasks count] forTask:task]];
    [viewController setSelectedTasks:selectedTasks];
    [viewController setParentTask:parentTask];
    [viewController setDelegate:delegate];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - System

/*- (void)dealloc
{
    [data release];
    data = nil;
    [task release];
    task = nil;
}*/

@end

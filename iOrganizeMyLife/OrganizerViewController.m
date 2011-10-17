//
//  FirstViewController.m
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OrganizerViewController.h"
#import "iOrganize_My_LifeAppDelegate.h"
#import "TaskDetailViewController.h"

#define DELETE_ACTION_SHEET_TAG 1


@interface OrganizerViewController()

- (void)add:(id)sender;
- (void)edit:(id)sender;
- (void)delete:(id)sender;
- (void)move:(id)sender;
- (void)keyboardSetup:(NSNotification *)notification;
- (void)configureToolbarButtons;
- (void)insertMovedRowsIntoTableView:(NSNotification *)notification;

@end


@implementation OrganizerViewController

@synthesize tableView, data, task;

#pragma mark - ViewController Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) 
    {
        // Custom initialization
        [self setData:[(iOrganize_My_LifeAppDelegate *)[[UIApplication sharedApplication] delegate] data]];
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
        [self setData:[(iOrganize_My_LifeAppDelegate *)[[UIApplication sharedApplication] delegate] data]];
        [self setTask:[self.data rootTask]];
    }
    
    [self configureToolbarButtons];
    self.navigationItem.title = [data titleForTask:self.task];
    
    selectedTasks = [[NSMutableArray alloc] init];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertMovedRowsIntoTableView:) name:@"DidFinishMovingWithTargetTask" object:nil];
    
    //[self.view addSubview:newTaskView];
    //[newTaskTextField setInputAccessoryView:newTaskView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardSetup:) name:@"UIKeyboardWillShowNotification" object:nil];
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

- (void)add:(id)sender
{
    [self.view addSubview:newTaskBackgroundButton];
    [self.view addSubview:newTaskView];
    //[newTaskTextField 
    [newTaskBackgroundButton addTarget:self action:@selector(dismissNewTaskView:) forControlEvents:UIControlEventTouchUpInside];
    [newTaskTextField becomeFirstResponder];
}

- (void)delete:(id)sender
{
    NSString *text;
    if([selectedTasks count] == 1)
    {
        text = @"Are you sure you want to delete this task and all of its corresponding subtasks? This action cannot be undone!";
    }
    else
    {
        text = [NSString stringWithFormat:@"Are you sure you want to delete these %d tasks and all of their corresponding subtasks? This action cannot be undone!", [selectedTasks count]];
    }
    
    UIActionSheet *deleteConfirmationSheet = [[UIActionSheet alloc] initWithTitle:text delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [deleteConfirmationSheet setTag:1];
    [deleteConfirmationSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [deleteConfirmationSheet showFromTabBar:self.tabBarController.tabBar];
    [deleteConfirmationSheet release];
}

- (void)move:(id)sender
{
    /*// Replace the NSIndexPath's of the tasks with the actual tasks
    for(int i = 0; i < [selectedTasks count]; i ++)
    {
        [selectedTasks replaceObjectAtIndex:i withObject:[self.data subtaskAtIndex:[[selectedTasks objectAtIndex:i] row] forTask:task]];
    }*/
    
    OrganizerMovingViewController *viewController = [[OrganizerMovingViewController alloc] initWithNibName:@"OrganizerMovingView" bundle:nil];
    // This makes the default location of the moving view the current view
    [viewController setTask:task];
    [viewController setSelectedTasks:selectedTasks];
    [viewController setParentTask:task];
    [viewController setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController presentModalViewController:navController animated:YES];
    [viewController release];
    [navController release];
}

- (void)edit:(id)sender
{
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
    [self configureToolbarButtons];
    if(![self.tableView isEditing])
    {
        [selectedTasks removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (void)keyboardSetup:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameBeginning = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginningRect = [keyboardFrameBeginning CGRectValue];
    CGRect textViewRect = [newTaskView frame];
    textViewRect.origin.y = self.view.frame.size.height - textViewRect.size.height - keyboardFrameBeginningRect.size.height + 50;
    [newTaskView setFrame:textViewRect];
}

- (void)configureToolbarButtons
{
    if([self.tableView isEditing])
    {
        // Only make changes to the buttons when necessary
        if([selectedTasks count] <= 1)
        {
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit:)];
            self.navigationItem.rightBarButtonItem = cancelButton;
            [cancelButton release];
            
            // Toolbar buttons
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Garbage Can.tif"] style:UIBarButtonItemStylePlain target:self action:@selector(delete:)];
            UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MovingFolder.tif"] style:UIBarButtonItemStylePlain target:self action:@selector(move:)];
            if([selectedTasks count] == 0)
            {
                [deleteButton setEnabled:NO];
                [moveButton setEnabled:NO];
            }
            [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, deleteButton, flexibleSpace, moveButton, flexibleSpace, nil]];
            [deleteButton release];
            [moveButton release];
        }
    }
    else
    {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
        self.navigationItem.rightBarButtonItem = addButton;
        [addButton release];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
        [toolbar setItems:[NSArray arrayWithObject:editButton]];
        [editButton release];
    }
}

#pragma mark - Methods

- (IBAction)dismissNewTaskView:(id)sender
{
    [newTaskBackgroundButton removeFromSuperview];
    [newTaskView removeFromSuperview];
    [newTaskTextField resignFirstResponder];
}

- (IBAction)newTaskTypeSelector:(id)sender
{
    
}

#pragma mark - OrganizerMovingViewControllerDelegate Methods

- (void)didCancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didFinishMoving
{
    // Toggle editing if there are no tasks left
    if([self.data subtaskCountForTask:task] == 0)
    {
        [self edit:nil];
    }
    [selectedTasks removeAllObjects];
    [self configureToolbarButtons];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
}

- (void)insertMovedRowsIntoTableView:(NSNotification *)notification
{
    NSMutableDictionary *targetTask = [[notification userInfo] objectForKey:@"task"];
    selectedTasks = [[notification userInfo] objectForKey:@"selectedTasks"];
    if([[self.data filePathForTask:targetTask] isEqualToString:[self.data filePathForTask:self.task]])
    {
        self.task = targetTask;
        
        /*// Move each of the tasks
        for(int i = [selectedTasks count] - 1; i >= 0; i --)
        {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[selectedTasks objectAtIndex:i]] withRowAnimation:UITableViewRowAnimationTop];
        }*/
    }
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet tag] == DELETE_ACTION_SHEET_TAG && buttonIndex == [actionSheet destructiveButtonIndex])
    {
        // Sort the selected task, otherwise deleting them will cause major issues (indexes get all messed up)
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
        
        // Remove each of the tasks
        for(int i = [selectedTasks count] - 1; i >= 0; i --)
        {
            [data deleteSubtaskAtIndex:[[selectedTasks objectAtIndex:i] row] forTask:task];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[selectedTasks objectAtIndex:i]] withRowAnimation:UITableViewRowAnimationRight];
        }
        
        // Toggle editing if there are no tasks left
        if([self.data subtaskCountForTask:task] == 0)
        {
            [self edit:nil];
        }
        [selectedTasks removeAllObjects];
        [self configureToolbarButtons];
        [self.tableView reloadData];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([[newTaskTextField text] isEqualToString:@""])
    {
        [self dismissNewTaskView:nil];
        [self.tableView reloadData];
    }
    else
    {
        [data addSubtaskWithTitle:[newTaskTextField text] forTask:task];
        //[self.tableView reloadData];
        [newTaskTextField setText:@""];
        [self.tableView reloadData];
    }
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSLog(@"subtaskCount:%d", [data subtaskCountForTask:task]);
    NSLog(@"task:%@", [self task]);
    return [data subtaskCountForTask:task];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    NSMutableDictionary *subtask = [data subtaskAtIndex:[indexPath row] forTask:task];
    
    // Update the cell
    NSLog(@"subtask for cell %d: %@", [indexPath row], subtask);
    NSLog(@"title for cell %d: %@", [indexPath row], [data titleForTask:subtask]);
    [[cell textLabel] setText:[data titleForTask:subtask]];
    
    if([self.tableView isEditing])
    {
        if([selectedTasks containsObject:indexPath])
        {
            [[cell imageView] setImage:[UIImage imageNamed:@"Selected.tif"]];
        }
        else
        {
            [[cell imageView] setImage:[UIImage imageNamed:@"EmptySelection.tif"]];
        }
    }
    else
    {
        // TODO: Show the priority
        if([data subtaskCountForTask:[data subtaskAtIndex:[indexPath row] - [selectedTasks count] forTask:task]] < 1)
        {
            [[cell imageView] setImage:[UIImage imageNamed:@"GreenCircle.png"]];
        }
        else
        {
            [[cell imageView] setImage:[UIImage imageNamed:@"GreenCircleGreenDetail.png"]];
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // Remove the subtask
        [data deleteSubtaskAtIndex:[indexPath row] forTask:task];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
    [self.tableView reloadData];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [data moveSubtaskAtIndex:[fromIndexPath row] toIndex:[toIndexPath row] forTask:task];
}

 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    //NSLog(@"selected row:%d", [indexPath row]);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.tableView isEditing])
    {
        if([selectedTasks containsObject:indexPath])
        {
            [selectedTasks removeObject:indexPath];
        }
        else
        {
            [selectedTasks addObject:indexPath];
        }
        [self configureToolbarButtons];
        [self.tableView reloadData];
    }
    else
    {
        OrganizerViewController *viewController = [[OrganizerViewController alloc] initWithNibName:@"OrganizerView" bundle:nil];
        [viewController setTask:[data subtaskAtIndex:[indexPath row] forTask:task]];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    TaskDetailViewController *viewController = [[TaskDetailViewController alloc] initWithNibName:@"TaskDetailView" bundle:nil];
    [viewController setTask:[data subtaskAtIndex:[indexPath row] forTask:task]];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end

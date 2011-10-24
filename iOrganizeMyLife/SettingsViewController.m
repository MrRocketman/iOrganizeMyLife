//
//  SettingsViewController.m
//  iOrganize My Life
//
//  Created by James Adams on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController()

- (NSString *)libraryDirectory;
- (NSString *)hiddenDocumentsDirectory;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;

@end

@implementation SettingsViewController

@synthesize currentPath, currentPathContents;

#pragma mark System Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    
    // Top level viewController
    if([currentPath length] <= 0)
    {
        self.currentPath = [self libraryDirectory];
    }
    // Files
    else if([[currentPath pathExtension] length] > 0)
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:currentPath];
        NSLog(@"dictionary:%@", dictionary);
        [dictionary release];
    }
    
    self.currentPathContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentPath error:NULL];
    [theTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [theTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark My Methods

- (NSString *)libraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)hiddenDocumentsDirectory
{
	NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
	NSString *path = [libraryPath stringByAppendingPathComponent:@"Private Documents"];
	
	BOOL isDirectory = NO;
	if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) 
    {
		if (isDirectory) 
        {
			return path;
		}
        else 
        {
			[NSException raise:@"'Private Documents' exists, and is a file" format:@"Path: %@", path];
		}
	}
    
	NSError *error = nil;
	if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) 
    {
		[NSException raise:@"Failed creating directory" format:@"[%@], %@", path, error];
	}
    
	return path;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSLog(@"%d rows", [currentPathContents count]);
    return [currentPathContents count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    // Update the cell
    NSLog(@"cell %d: %@", [indexPath row], [currentPathContents objectAtIndex:[indexPath row]]);
    [[cell textLabel] setText:[currentPathContents objectAtIndex:[indexPath row]]];
    
    if([[[currentPathContents objectAtIndex:[indexPath row]] pathExtension] length] > 0)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
}


// Customize the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingsViewController *viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    [viewController setCurrentPath:[currentPath stringByAppendingFormat:@"/%@", [currentPathContents objectAtIndex:[indexPath row]]]];
    NSLog(@"Set viewController Path:%@", [viewController currentPath]);
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


@end

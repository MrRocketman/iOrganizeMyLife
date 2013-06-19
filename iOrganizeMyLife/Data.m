//
//  Data.m
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Data.h"
#define LARGEST_NUMBER 9999


@interface Data()

//- (void)moveAllFiles;
//- (void)fixPermissionsForFilePath:(NSString *)path;
//- (NSString *)hiddenDocumentsDirectory;
//- (void)changeAllFilesFilePaths;
- (NSString *)libraryDirectory;
- (NSString *)absoluteFilePathFromRelativeFilePath:(NSString *)filePath;
- (float)versionNumber;
- (void)setVersionNumber:(float)versionNumber;

- (NSString *)nextAvailableNumberForSubtaskFilePath:(NSMutableDictionary *)task;
- (void)setSubtaskFilePaths:(NSMutableArray *)subtaskFilePaths forTask:(NSMutableDictionary *)task;
- (void)setFilePath:(NSString *)filePath forTask:(NSMutableDictionary *)task;
- (NSString *)subtaskFilePathAtIndex:(int)index forTask:(NSMutableDictionary *)task;
- (NSMutableArray *)subtaskFilePathsForTask:(NSMutableDictionary *)task;
- (void)saveDataForTask:(NSMutableDictionary *)task;

@end


@implementation Data

- (id)init
{
    self = [super init];
    if(self) 
    {
        // Initialization code here.
        [self load];
    }
    
    return self;
}

- (void)dealloc
{
    [data release];
    [rootTask release];
    [super dealloc];
}

#pragma mark - Private Methods

/*
- (void)moveAllFiles
{
    // Copy from private documents to library
    NSError *error = nil;
    NSString *filePath = [NSString stringWithFormat:@"%@/iOrganize.ioml", [self hiddenDocumentsDirectory]];
    [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:[[self libraryDirectory] stringByAppendingString:@"/iOrganize.ioml"] error:&error];
    if(error)
        NSLog(@"error 2:%@\n\n", error);
    filePath = [NSString stringWithFormat:@"%@/iOrganize.task", [self hiddenDocumentsDirectory]];
    [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:[[self libraryDirectory] stringByAppendingString:@"/iOrganize.task"] error:&error];
    if(error)
        NSLog(@"error 4:%@\n\n", error);
    filePath = [NSString stringWithFormat:@"%@/iOrganize", [self hiddenDocumentsDirectory]];
    [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:[[self libraryDirectory] stringByAppendingString:@"/iOrganize"] error:&error];
    if(error)
        NSLog(@"error 6:%@\n\n", error);
    NSLog(@"Done copying");
}
 */

/*
- (void)fixPermissionsForFilePath:(NSString *)path
{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    if ([manager fileExistsAtPath: path]) 
    {
        NSDictionary *attrib = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:0], NSFileGroupOwnerAccountID,
                                [NSNumber numberWithInt:0], NSFileOwnerAccountID,
                                @"root", NSFileGroupOwnerAccountName,
                                @"root", NSFileOwnerAccountName, nil ];
        NSError *error = nil;
        [manager setAttributes:attrib ofItemAtPath:path error:&error];
        
        NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath: path];
        NSString *file;
        while (file = [dirEnum nextObject]) 
        {
            [manager setAttributes:attrib ofItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
        }
    }
}
 */

/*
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
 */

- (NSString *)libraryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)absoluteFilePathFromRelativeFilePath:(NSString *)filePath
{
    return [NSString stringWithFormat:@"%@/%@", [self libraryDirectory], filePath];
}

- (float)versionNumber
{
    return [[data objectForKey:@"versionNumber"] floatValue];
}

- (void)setVersionNumber:(float)versionNumber
{
    [data setObject:[NSNumber numberWithFloat:versionNumber] forKey:@"versionNumber"];
}

- (NSString *)nextAvailableNumberForSubtaskFilePath:(NSMutableDictionary *)task
{
    int currentNumber = -1;
    int previousNumbers[LARGEST_NUMBER] = {0};
    int largestNumber = -1;
    int smallestNumber = LARGEST_NUMBER;
    int availableNumber = -1;
    NSMutableArray *theSubtaskFilesPaths = [self subtaskFilePathsForTask:task];
    
    for(int i = 0; i < [theSubtaskFilesPaths count]; i ++)
    {
        // Gives just the number of the file name without the extension
        currentNumber = [[[[theSubtaskFilesPaths objectAtIndex:i] lastPathComponent] stringByDeletingPathExtension] intValue];
        previousNumbers[currentNumber] = 1;
        
        // Check for the smallestNumber
        if(currentNumber < smallestNumber)
        {
            smallestNumber = currentNumber;
        }
        // Check for the largest number
        if(currentNumber > largestNumber)
        {
            largestNumber = currentNumber;
        }
    }
    
    // Smallest numbers take priority
    if(smallestNumber < LARGEST_NUMBER && smallestNumber > 0)
    {
        availableNumber = smallestNumber - 1;
    }
    // Gap numbers take next priority
    if(availableNumber == -1)
    {
        for(int i = 0; i < largestNumber; i ++)
        {
            if(previousNumbers[i] == 0 && availableNumber == -1)
            {
                availableNumber = i;
                // End the loop
                i = largestNumber;
            }
        }
    }
    // And then finally the largest number
    if(availableNumber == -1)
    {
        availableNumber = largestNumber + 1;
    }
    
    return [NSString stringWithFormat:@"%d", availableNumber];
}

- (void)setSubtaskFilePaths:(NSMutableArray *)subtaskFilePaths forTask:(NSMutableDictionary *)task
{
    //NSLog(@"settingSubtaskFilePaths to:%@ for task:%@", subtaskFilePaths, task);
    [task setObject:subtaskFilePaths forKey:@"subtaskFilePaths"];
}

- (NSString *)filePathForTask:(NSMutableDictionary *)task
{
    //NSLog(@"filePath:%@ for task:%@", [task objectForKey:@"filePath"], task);
    return [task objectForKey:@"filePath"];
}

- (NSString *)subtaskFilePathAtIndex:(int)index forTask:(NSMutableDictionary *)task
{
    NSMutableArray *subtaskFilesPaths = [self subtaskFilePathsForTask:task];
    if(index < [subtaskFilesPaths count])
        return [subtaskFilesPaths objectAtIndex:index];
    else
        return nil;
    //return [[self subtaskFilePathsForTask:task] objectAtIndex:index];
}
- (NSMutableArray *)subtaskFilePathsForTask:(NSMutableDictionary *)task
{
    //NSLog(@"read subtaskFilePaths as:%@ for task:%@", (NSMutableArray *)[task objectForKey:@"subtaskFilePaths"], task);
    return (NSMutableArray *)[task objectForKey:@"subtaskFilePaths"];
}

- (void)saveDataForTask:(NSMutableDictionary *)task
{
    [task writeToFile:[self absoluteFilePathFromRelativeFilePath:[self filePathForTask:task]] atomically:YES];
    //NSLog(@"save success:%d", success);
}

#pragma mark - Main Methods

- (void)load
{
    // This file contains info like the version number
    NSString *filePath = [self absoluteFilePathFromRelativeFilePath:@"iOrganize.ioml"];
    BOOL isDirectory = NO;
    
    // Read in the data
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    // First time being opened. Create the top level task
    else
    {
        data = [[NSMutableDictionary alloc] init];
        [self addSubtaskWithTitle:@"iOrganize" forTask:nil];
        [self setVersionNumber:VERSION_NUMBER];
        [data writeToFile:filePath atomically:YES];
    }
}

#pragma mark - Data

- (NSMutableDictionary *)rootTask
{
    if(!rootTask)
    {
        rootTask = [[NSMutableDictionary alloc] initWithContentsOfFile:[self absoluteFilePathFromRelativeFilePath:@"iOrganize.task"]];
    }
    
    return rootTask;
}
            
- (int)priorityForTask:(NSMutableDictionary *)task
{
    return [[task objectForKey:@"priority"] intValue];
}

- (NSString *)titleForTask:(NSMutableDictionary *)task
{
    //NSLog(@"taskTitle:%@", [task objectForKey:@"title"]);
    //NSLog(@"task:%@", task);
    return [task objectForKey:@"title"];
}

- (NSMutableDictionary *)subtaskAtIndex:(int)index forTask:(NSMutableDictionary *)task
{
    NSString *filePath = [self absoluteFilePathFromRelativeFilePath:[self subtaskFilePathAtIndex:index forTask:task]];
    NSMutableDictionary *subtask = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    return subtask;
}

- (int)subtaskCountForTask:(NSMutableDictionary *)task
{
    return [[self subtaskFilePathsForTask:task] count];
}

- (void)addSubtaskWithTitle:(NSString *)title forTask:(NSMutableDictionary *)task
{
    NSMutableDictionary *newTask = [[NSMutableDictionary alloc] init];
    [self setPriority:kLow forTask:newTask];
    [self setTitle:title forTask:newTask];
    NSMutableArray *newSubtaskFilePaths = [[NSMutableArray alloc] init];
    [self setSubtaskFilePaths:newSubtaskFilePaths forTask:newTask];
    [newSubtaskFilePaths release];
    
    NSString *filePath;
    // Top level task (iOrganize.task)
    if(task == nil)
    {
        filePath = [self absoluteFilePathFromRelativeFilePath:title];
    }
    // All other tasks
    else
    {
        // New subtasks get a file name chosen by availble numbers (detemined by @selector(nextAvailableNumberForSubtaskFilePath)
        filePath = [NSString stringWithFormat:@"%@/%@.task", [[self filePathForTask:task] stringByDeletingPathExtension], [self nextAvailableNumberForSubtaskFilePath:task]];
    }
    [self setFilePath:filePath forTask:newTask];
    if(task != nil)
    {
      [[self subtaskFilePathsForTask:task] addObject:filePath];
    }
    
    // Create the folder
    NSError *error = nil;
	if(![[NSFileManager defaultManager] createDirectoryAtPath:[self absoluteFilePathFromRelativeFilePath:[filePath stringByDeletingPathExtension]] withIntermediateDirectories:YES attributes:nil error:&error])
    {
		[NSException raise:@"Failed creating directory" format:@"[%@], %@", filePath, error];
	}
    
    // Save the task and the new subtask
    if(task != nil)
        [self saveDataForTask:task];
    
    [self saveDataForTask:newTask];
    [newTask release];
}
            
- (void)setPriority:(int)priority forTask:(NSMutableDictionary *)task
{
    [task setObject:[NSNumber numberWithInt:priority] forKey:@"priority"];
    [self saveDataForTask:task];
}

- (void)setTitle:(NSString *)title forTask:(NSMutableDictionary *)task
{
    [task setObject:title forKey:@"title"];
    [self saveDataForTask:task];
}

// This is a VERY Private method. Under no circumstances should this be called except for when adding a new subtask because the app depends on a structured file naming convention
- (void)setFilePath:(NSString *)filePath forTask:(NSMutableDictionary *)task
{
    [task setObject:filePath forKey:@"filePath"];
    [self saveDataForTask:task];
}

- (void)deleteSubtaskAtIndex:(int)index forTask:(NSMutableDictionary *)task
{
    // Delete the task file
    NSString *filePath = [self filePathForTask:[self subtaskAtIndex:index forTask:task]];
    [[NSFileManager defaultManager] removeItemAtPath:[self absoluteFilePathFromRelativeFilePath:filePath] error:NULL];
    // Delete the associated folder and everything in the folder
    [[NSFileManager defaultManager] removeItemAtPath:[self absoluteFilePathFromRelativeFilePath:[filePath stringByDeletingPathExtension]] error:NULL];
    
    // Delete the filePath reference from the parent
    NSMutableArray *filePaths = [self subtaskFilePathsForTask:task];
    [filePaths removeObjectAtIndex:index];
    [self setSubtaskFilePaths:filePaths forTask:task];
    [self saveDataForTask:task];
}

// Reorder subtasks for a task
- (void)moveSubtaskAtIndex:(int)index toIndex:(int)newIndex forTask:(NSMutableDictionary *)task
{
    NSMutableArray *filePaths = [self subtaskFilePathsForTask:task];
    NSString *filePath = [[self subtaskFilePathAtIndex:index forTask:task] retain];
    [filePaths removeObjectAtIndex:index];
    [filePaths insertObject:filePath atIndex:newIndex];
    [filePath release];
    [self saveDataForTask:task];
}

// Move subtasks from one task to another
- (void)moveSubtaskAtIndex:(int)fromIndex forTask:(NSMutableDictionary *)fromTask toIndex:(int)toIndex forTask:(NSMutableDictionary *)toTask
{
    NSMutableDictionary *theTask = [self subtaskAtIndex:fromIndex forTask:fromTask];
    
    // Create the new task and set its title
    [self addSubtaskWithTitle:[self titleForTask:theTask] forTask:toTask];
    NSMutableDictionary *theNewTask = [self subtaskAtIndex:[self subtaskCountForTask:toTask] - 1 forTask:toTask];
    // Reassign the priority
    [self setPriority:[self priorityForTask:theTask] forTask:theNewTask];
    // Move the task to to correct position within the new task
    [self moveSubtaskAtIndex:[self subtaskCountForTask:toTask] - 1 toIndex:toIndex forTask:toTask];
    
    // Recursively move the subtasks of the original task to their new location
    // Must store the original subtask count because the count changes as we delete the subtasks!!
    int subtaskCount = [self subtaskCountForTask:theTask] - 1;
    // Must go from largest index to smallest, because the indexes are shifting down as we delete subtasks
    for(int i = subtaskCount; i >= 0; i --)
    {
        // The 'toIndex' has to be a constant. Because the objects need to be deleted by largest index first and inserted by smallest index first. Or First in, Last out. Using a constant for 'toInex' accomplishes the task simply.
        [self moveSubtaskAtIndex:i forTask:theTask toIndex:0 forTask:theNewTask];
    }
    
    // Delete the original task
    [self deleteSubtaskAtIndex:fromIndex forTask:fromTask];
}

@end

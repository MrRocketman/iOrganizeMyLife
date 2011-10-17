//
//  Data.m
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Data.h"


@interface Data()

- (NSString *)hiddenDocumentsDirectory;
- (float)versionNumber;
- (void)setVersionNumber:(float)versionNumber;

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

#pragma mark - Private Methods

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

- (float)versionNumber
{
    return [[data objectForKey:@"versionNumber"] floatValue];
}

- (void)setVersionNumber:(float)versionNumber
{
    [data setObject:[NSNumber numberWithFloat:versionNumber] forKey:@"versionNumber"];
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
    [task writeToFile:[self filePathForTask:task] atomically:YES];
    //NSLog(@"save success:%d", success);
}

#pragma mark - Main Methods

- (void)load
{
    // This file contains info like the version number
    NSString *filePath = [NSString stringWithFormat:@"%@/iOrganize.ioml", [self hiddenDocumentsDirectory]];
    BOOL isDirectory = NO;
    
    // Data has been saved before
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) 
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }
    // First time being opened
    else
    {
        data = [[NSMutableDictionary alloc] init];
        [self addSubtaskWithTitle:@"iOrganize" forTask:nil];
        [self setVersionNumber:VERSION_NUMBER];
        [data writeToFile:filePath atomically:YES];
        //NSLog(@"data:%@", data);
        //NSLog(@"main filePath:%@", filePath);
        //NSLog(@"main save success:%d", success);
    }
}

#pragma mark - Data

- (NSMutableDictionary *)rootTask
{
    return [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/iOrganize.task", [self hiddenDocumentsDirectory]]];
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
    NSString *filePath = [self subtaskFilePathAtIndex:index forTask:task];
    NSLog(@"data filePath:%@", filePath);
    NSMutableDictionary *subtask = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    NSLog(@"data subtask:%@", subtask);
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
    // Top level task
    if(task == nil)
    {
        filePath = [NSString stringWithFormat:@"%@/%@.task", [self hiddenDocumentsDirectory], title];
    }
    // All other tasks
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@.task", [[self filePathForTask:task] stringByReplacingOccurrencesOfString:@".task" withString:@""], title];
    }
    [self setFilePath:filePath forTask:newTask];
    if(task != nil)
    {
      [[self subtaskFilePathsForTask:task] addObject:filePath];
    }
    
    // Create the folder
    NSError *error = nil;
	if(![[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByReplacingOccurrencesOfString:@".task" withString:@""] withIntermediateDirectories:YES attributes:nil error:&error]) 
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

- (void)setFilePath:(NSString *)filePath forTask:(NSMutableDictionary *)task
{
    [task setObject:filePath forKey:@"filePath"];
    [self saveDataForTask:task];
}

- (void)deleteSubtaskAtIndex:(int)index forTask:(NSMutableDictionary *)task
{
    // Delete the task
    [[NSFileManager defaultManager] removeItemAtPath:[self filePathForTask:[self subtaskAtIndex:index forTask:task]] error:NULL];
    // Delete the associated folder
    [[NSFileManager defaultManager] removeItemAtPath:[[self filePathForTask:[self subtaskAtIndex:index forTask:task]] stringByReplacingOccurrencesOfString:@".task" withString:@""] error:NULL];
    
    // Delete the filePath reference
    NSMutableArray *filePaths = [self subtaskFilePathsForTask:task];
    [filePaths removeObjectAtIndex:index];
    [self setSubtaskFilePaths:filePaths forTask:task];
    [self saveDataForTask:task];
}

- (void)moveSubtaskAtIndex:(int)index toIndex:(int)newIndex forTask:(NSMutableDictionary *)task
{
    NSMutableArray *filePaths = [self subtaskFilePathsForTask:task];
    NSString *filePath = [[filePaths objectAtIndex:index] retain];
    [filePaths removeObjectAtIndex:index];
    [filePaths insertObject:filePath atIndex:newIndex];
    [filePath release];
    [self saveDataForTask:task];
}

- (void)moveSubtaskAtIndex:(int)fromIndex forTask:(NSMutableDictionary *)fromTask toIndex:(int)toIndex forTask:(NSMutableDictionary *)toTask
{
    NSMutableDictionary *theTask = [self subtaskAtIndex:fromIndex forTask:fromTask];
    
    // Create the new task
    [self addSubtaskWithTitle:[self titleForTask:theTask] forTask:toTask];
    NSMutableDictionary *theNewTask = [self subtaskAtIndex:[self subtaskCountForTask:toTask] - 1 forTask:toTask];
    [self setPriority:[self priorityForTask:theTask] forTask:theNewTask];
    [self moveSubtaskAtIndex:[self subtaskCountForTask:toTask] - 1 toIndex:toIndex forTask:toTask];
    
    // Recursively move the subtasks
    int subtaskCount = [self subtaskCountForTask:theTask] - 1; // Must store the original count because the count changes as we delete the subtasks!!
    for(int i = subtaskCount; i >= 0; i --) // Must go from largest index to smallest, otherwise the indexes would be changes and messing everything up
        
    {
        // The 'toIndex' has to be a constant. Because the objects need to be deleted by largest index first and inserted by smallest index first. Or First in, Last out. Using a constant for 'toInex' accomplishes the task simply.
        [self moveSubtaskAtIndex:i forTask:theTask toIndex:0 forTask:theNewTask];
    }
    
    // Delete the original task
    [self deleteSubtaskAtIndex:fromIndex forTask:fromTask];
}

@end

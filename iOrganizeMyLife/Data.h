//
//  Data.h
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 Pencil Busters, Inc. All rights reserved.
//

/*
 ################ Data Model #################
 "iOrganzie.ioml"
 * NSMutableDictionary *task; (Top level data object) "iOrganize.task"
    - NSNumber *priority;
    - NSString *title;
    - NSString *filePath;
    - NSMutableArray *subTaskFilePaths; (An Array of Tasks)
        * FilePaths are given a numerical name. ie "1.task, 2.task"
 - NSNumber *versionNumber;
 */

#import <Foundation/Foundation.h>
#define VERSION_NUMBER 1.0

enum kPriority
{
    kLow,
    kMedium,
    kHigh,
    kCheckmark
};

@interface Data : NSObject
{
    // The top level data. ie "iOrganize.ioml"
    NSMutableDictionary *data;
    NSMutableDictionary *rootTask;
}

// Main methods
- (void)load;

// Data methods
- (NSMutableDictionary *)rootTask;
- (int)priorityForTask:(NSMutableDictionary *)task;
- (NSString *)titleForTask:(NSMutableDictionary *)task;
- (NSString *)filePathForTask:(NSMutableDictionary *)task;

- (NSMutableDictionary *)subtaskAtIndex:(int)index forTask:(NSMutableDictionary *)task;
- (int)subtaskCountForTask:(NSMutableDictionary *)task;

- (void)addSubtaskWithTitle:(NSString *)title forTask:(NSMutableDictionary *)task;

- (void)setPriority:(int)priority forTask:(NSMutableDictionary *)task;
- (void)setTitle:(NSString *)title forTask:(NSMutableDictionary *)task;
- (void)deleteSubtaskAtIndex:(int)index forTask:(NSMutableDictionary *)task;
- (void)moveSubtaskAtIndex:(int)index toIndex:(int)newIndex forTask:(NSMutableDictionary *)task;
- (void)moveSubtaskAtIndex:(int)fromIndex forTask:(NSMutableDictionary *)fromTask toIndex:(int)toIndex forTask:(NSMutableDictionary *)toTask;

@end

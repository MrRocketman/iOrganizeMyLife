//
//  Data.h
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 Pencil Busters, Inc. All rights reserved.
//

/*
 ################ Data Model #################
 * NSMutableDictionary *task; (Top level data object)
    - NSNumber *priority;
    - NSString *title;
    - NSString *filePath;
    - NSMutableArray *subTaskFilePaths; (An Array of Tasks)
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
    NSMutableDictionary *data;
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

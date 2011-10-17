//
//  FirstViewController.h
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@protocol OrganizerMovingViewControllerDelegate <NSObject>

- (void)didCancel;
- (void)didFinishMoving;

@end

@interface OrganizerMovingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIToolbar *toolbar;
    
    id<OrganizerMovingViewControllerDelegate> delegate;
    
    Data *data;
    NSMutableDictionary *task;
    
    NSMutableDictionary *parentTask;
    NSMutableArray *selectedTasks;
}

@property(readwrite, retain) UITableView *tableView;

@property(readwrite, assign) id<OrganizerMovingViewControllerDelegate> delegate;

@property(readwrite, retain) Data *data;
@property(readwrite, retain) NSMutableDictionary *task;

@property(readwrite, retain) NSMutableDictionary *parentTask;
@property(readwrite, retain) NSMutableArray *selectedTasks;

@end

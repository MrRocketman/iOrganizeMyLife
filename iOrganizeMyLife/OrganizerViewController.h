//
//  FirstViewController.h
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import "OrganizerMovingViewController.h"
#import "PriorityChangerViewController.h"


@interface OrganizerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, OrganizerMovingViewControllerDelegate, PriorityChangerViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIToolbar *toolbar;
    
    IBOutlet UIButton *newTaskBackgroundButton;
    IBOutlet UIView *newTaskView;
    IBOutlet UITextField *newTaskTextField;
    
    IBOutlet PriorityChangerViewController *priorityChanger;
    int indexOfPriorityChangingTask;
    
    Data *data;
    NSMutableDictionary *task;
    
    NSMutableArray *selectedTasks;
}

@property(readwrite, retain) UITableView *tableView;

@property(readwrite, retain) Data *data;
@property(readwrite, retain) NSMutableDictionary *task;

@property(readwrite, retain) PriorityChangerViewController *priorityChanger;

- (IBAction)dismissNewTaskView:(id)sender;
- (IBAction)newTaskTypeSelector:(id)sender;

- (void)priorityButtonTapped:(id)sender;

@end

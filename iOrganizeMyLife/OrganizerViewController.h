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


@interface OrganizerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, OrganizerMovingViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIToolbar *toolbar;
    
    IBOutlet UIButton *newTaskBackgroundButton;
    IBOutlet UIView *newTaskView;
    IBOutlet UITextField *newTaskTextField;
    
    Data *data;
    NSMutableDictionary *task;
    
    NSMutableArray *selectedTasks;
}

@property(readwrite, retain) UITableView *tableView;

@property(readwrite, retain) Data *data;
@property(readwrite, retain) NSMutableDictionary *task;

- (IBAction)dismissNewTaskView:(id)sender;
- (IBAction)newTaskTypeSelector:(id)sender;

@end

//
//  TaskDetailViewController.h
//  iOrganize My Life
//
//  Created by James Adams on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

#define NUMBER_OF_SECTIONS 1
#define TASK_TITLE_SECTION 0

#define TASK_TITLE_NUMBER_OF_ROWS 1
#define TASK_TITLE_ROW 0

@interface TaskDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    Data *data;
    NSMutableDictionary *task;
    
    IBOutlet UITableView *tableView;
    IBOutlet UITableViewCell *tableViewTextFieldCell;
    IBOutlet UITextField *textField;
}

@property(readwrite, retain) Data *data;
@property(readwrite, retain) NSMutableDictionary *task;

@property(readwrite, retain) UITableView *tableView;

@end

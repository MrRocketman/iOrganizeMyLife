//
//  SettingsViewController.h
//  iOrganize My Life
//
//  Created by James Adams on 7/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *currentPath;
    NSArray *currentPathContents;
    
    IBOutlet UITableView *theTableView;
}

@property(readwrite, retain) NSString *currentPath;
@property(readwrite, retain) NSArray *currentPathContents;

@end

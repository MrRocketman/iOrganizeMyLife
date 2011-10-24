//
//  TaskMarkerViewController.m
//  MyThings
//
//  Created by James R Adams on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PriorityChangerViewController.h"


@implementation PriorityChangerViewController

@synthesize delegate, label;

- (void)priorityButtonPress:(id)sender
{
	[delegate didFinishWithPriority:[(UIButton *)sender tag]];
}

- (IBAction)backgroundButtonPress:(id)sender
{
    [delegate shouldDismiss];
}

- (void)dealloc 
{
    [super dealloc];
}


@end

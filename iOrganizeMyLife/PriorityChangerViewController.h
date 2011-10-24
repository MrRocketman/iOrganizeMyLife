//
//  TaskMarkerView.h
//  MyThings
//
//  Created by James R Adams on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriorityChangerViewControllerDelegate <NSObject>

- (void)didFinishWithPriority:(int)newPriority;
- (void)shouldDismiss;

@end



@interface PriorityChangerViewController : UIViewController
{
	id<PriorityChangerViewControllerDelegate> delegate;
    
    IBOutlet UILabel *label;
}

@property(readwrite, assign) id<PriorityChangerViewControllerDelegate> delegate;
@property(readwrite, retain) UILabel *label;

- (IBAction)priorityButtonPress:(id)sender;
- (IBAction)backgroundButtonPress:(id)sender;

@end

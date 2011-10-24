//
//  OrganizerViewTableViewCell.h
//  iOrganizeMyLife
//
//  Created by James Adams on 10/18/11.
//  Copyright (c) 2011 Pencil Busters, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizerViewTableViewCell : UITableViewCell
{
    IBOutlet UIButton *priorityButton;
    IBOutlet UILabel *title;
}

@property(readwrite, retain) UIButton *priorityButton;
@property(readwrite, retain) UILabel *title;

@end

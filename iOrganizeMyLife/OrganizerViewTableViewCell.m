//
//  OrganizerViewTableViewCell.m
//  iOrganizeMyLife
//
//  Created by James Adams on 10/18/11.
//  Copyright (c) 2011 Pencil Busters, Inc. All rights reserved.
//

#import "OrganizerViewTableViewCell.h"

@implementation OrganizerViewTableViewCell

@synthesize priorityButton, title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

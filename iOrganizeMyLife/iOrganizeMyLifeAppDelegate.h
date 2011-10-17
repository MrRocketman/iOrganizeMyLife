//
//  iOrganize_My_LifeAppDelegate.h
//  iOrganize My Life
//
//  Created by James Adams on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface iOrganizeMyLifeAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>
{
    Data *data;
}

@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property(readwrite, retain) Data *data;

@end

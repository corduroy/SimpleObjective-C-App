//
//  DKAppDelegate.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKListViewController;
@class DKFirstViewController;


@interface DKAppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    DKListViewController *rootViewController;
    DKFirstViewController   *detailViewController;
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *rootPopoverButtonItem;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain)  UISplitViewController *splitViewController;
@property (nonatomic, retain)  DKListViewController *rootViewController;
@property (nonatomic, retain)  DKFirstViewController *detailViewController;
@property (nonatomic, assign) UIBarButtonItem *refreshButton;
@property (nonatomic, assign) UIBarButtonItem *rootPopoverButtonItem;


@end

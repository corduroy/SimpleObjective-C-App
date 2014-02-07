//
//  DKAppDelegate.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKListViewController;
@class DKDetailWebViewController;


@interface DKAppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    
    
    DKListViewController *rootViewController;
    DKDetailWebViewController   *detailViewController;
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *rootPopoverButtonItem;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain)  DKListViewController *rootViewController;
@property (nonatomic, retain)  DKDetailWebViewController *detailViewController;
@property (nonatomic, assign) UIBarButtonItem *refreshButton;
@property (nonatomic, assign) UIBarButtonItem *rootPopoverButtonItem;


@end

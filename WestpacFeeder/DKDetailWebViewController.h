//
//  DKFirstViewController.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKAppDelegate.h"


@interface DKDetailWebViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>{
    UIPopoverController *popoverController;
    DKAppDelegate *appDelegate;
}

@property (nonatomic, assign) DKAppDelegate *appDelegate;


@end

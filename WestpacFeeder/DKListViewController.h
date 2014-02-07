//
//  DKRootViewController.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DKFirstViewController;
@class DKAppDelegate;   //Note normally i would use a singleton rather than link back to DKAppDelegate


@interface DKListViewController : UITableViewController{
    DKFirstViewController *firstDetailViewController;
    DKAppDelegate *appDelegate;
}


@property (nonatomic, retain) DKFirstViewController *firstDetailViewController;
@property (nonatomic, assign) DKAppDelegate *appDelegate;
@end

//
//  DKFirstViewController.m
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import "DKDetailWebViewController.h"
#import "DKListViewController.h"
#import "DKAppDelegate.h"

@interface DKDetailWebViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;

@end

@implementation DKDetailWebViewController
@synthesize popoverController;
@synthesize appDelegate;


-(id) init {
	if (self=[super init]) {
		self.appDelegate = (DKAppDelegate*)[[UIApplication sharedApplication] delegate];
	}
	return self;
}


- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	barButtonItem.title = @"Latest";
    [[self navigationItem] setRightBarButtonItem:barButtonItem];
	[self setPopoverController:pc];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
    
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[[self navigationItem] setLeftBarButtonItem:nil];
	[self setPopoverController:nil];
	self.appDelegate.rootPopoverButtonItem = barButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[self navigationItem] setRightBarButtonItem:nil];
	}
	else {
		[[self navigationItem] setRightBarButtonItem:self.appDelegate.rootPopoverButtonItem];
	}
	return YES;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

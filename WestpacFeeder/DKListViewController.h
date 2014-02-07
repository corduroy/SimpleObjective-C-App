//
//  DKRootViewController.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "Reachability.h"
#import "DKThumbnailDownloader.h"

@class DKDetailWebViewController;
@class DKAppDelegate;   //Note normally i would use a singleton rather than link back to DKAppDelegate


@interface DKListViewController : UITableViewController<IconDownloaderDelegate,NSURLConnectionDataDelegate, UIWebViewDelegate>{
    DKDetailWebViewController *firstDetailViewController;
    DKAppDelegate *appDelegate;
}


@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;
@property (nonatomic, strong) NSMutableData *_data;
@property (nonatomic, strong) NSMutableDictionary   *iconImageDownloadsInProgress;
@property (nonatomic, readonly) int networkStatus;
@property (nonatomic, retain) DKDetailWebViewController *firstDetailViewController;
@property (nonatomic, assign) DKAppDelegate *appDelegate;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

- (BOOL)isJSONReachable;



@end

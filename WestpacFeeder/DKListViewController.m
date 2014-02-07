//
//  DKRootViewController.m
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import "DKListViewController.h"
#import "DKAppDelegate.h"
#import "AFNetworking.h"
#import "News.h"
#import "DKAPIManager.h"


static NSString * const ImageStateNormal = @"";
static NSString * const ImageStateSelected = @"_selected";


@interface DKListViewController (){
    NSArray         *_newsArray;
    NSIndexPath     *currentSelectedNews;
    UIColor         *textColor;
}

//- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath;
//- (void)deselectCellAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, assign) AFHTTPRequestOperation *operation;
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;


- (void)startIconDownload:(News *)news forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DKListViewController
@synthesize firstDetailViewController;
@synthesize appDelegate;
@synthesize iconImageDownloadsInProgress = _iconImageDownloadsInProgress;
@synthesize internetReach;
@synthesize wifiReach;
@synthesize networkStatus;
@synthesize webView;
@synthesize activityIndicator;
@synthesize hostReach;
@synthesize operation;
@synthesize _data;



- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (DKAppDelegate*) [[UIApplication sharedApplication] delegate];
	[self getNews:nil];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    
    activityIndicator.center = self.tableView.center;
    
    [self.tableView insertSubview:activityIndicator aboveSubview:self.tableView];
    
    
    [self monitorReachability];
    self.iconImageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshAction:)];
    
    [[self navigationItem] setLeftBarButtonItem:refreshButton];
    [refreshButton release];
    
    webView = [[UIWebView alloc] initWithFrame: self.view.frame];
    webView.delegate = self;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        currentSelectedNews = [NSIndexPath indexPathForRow:0 inSection:0];
        //[self selectCellAtIndexPath:currentSelectedNews];
    }
    
}


- (IBAction)refreshAction:(id)sender{
    [self getNews:nil];
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}


- (BOOL)isJSONReachable {
    return self.networkStatus != NotReachable;
}


- (void)monitorReachability {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:ReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName:NEWS_FEED_URL];
    [self.hostReach startNotifier];
    
    self.internetReach = [Reachability reachabilityForInternetConnection];
    [self.internetReach startNotifier];
    
    self.wifiReach = [Reachability reachabilityForLocalWiFi];
    [self.wifiReach startNotifier];
}


// Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    networkStatus = [curReach currentReachabilityStatus];
    
//    if (networkStatus == NotReachable) {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There's an issue iwth our server. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//        [alert show];
//    }
    
}


#pragma mark - Get News

- (void)getNews:(id)sender{
    
    DKAPIManager* client = [DKAPIManager sharedClient];
  
    NSURLRequest* jRequest  = [client requestWithMethod:@"GET" path:nil parameters:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [activityIndicator startAnimating];
    
    
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:3.0];
    self.tableView.alpha = 0.4;
    [UIView commitAnimations];
    
    
    operation = [[AFHTTPRequestOperation alloc]initWithRequest:jRequest];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DKDebug(@"IP Address: %@", [self.operation responseString]);
        
        [UIView beginAnimations:@"fade out" context:nil];
        [UIView setAnimationDuration:2.0];
        self.tableView.alpha = 1.0;
        [UIView commitAnimations];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [activityIndicator stopAnimating];
        
        //[self.refreshControl endRefreshing];
        NSData* data = [[DKAPIManager cleanJSONWithString:self.operation.responseString] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* dataList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _newsArray = [DKAPIManager createListOfNews:[dataList objectForKey:@"items"]];
        self.title=[dataList objectForKey:@"name"];
        [self.tableView reloadData];
        // End Refreshing
        //[self.operation release];
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DKDebug(@"error %@", error);
        // End Refreshing
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [activityIndicator stopAnimating];
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There's an issue iwth our server. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        
    }];
    // 8 - Start request
    [operation start];
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _newsArray.count-1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    News *object = _newsArray[indexPath.row];
    cell.textLabel.text = object.headLine;

    cell.detailTextLabel.text = object.slugLine;
    cell.detailTextLabel.numberOfLines = 3 ;
    
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!object.imageSmall)
    {
        DKDebug(@"object thumbnail %@", object.thumbnailImageHref);
        if (object.thumbnailImageHref != (id)[NSNull null])
            [self startIconDownload:object forIndexPath:indexPath];
        // if a download is deferred or in progress, return a placeholder image
        //imgDeal.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        [cell.imageView setImage:object.imageSmall];
    }
    
   
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   return 75;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(News *)news forIndexPath:(NSIndexPath *)indexPath
{
    DKThumbnailDownloader* iconDownloader = [_iconImageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[DKThumbnailDownloader alloc] init];
        iconDownloader.news = news;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [_iconImageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        iconDownloader = nil;
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([_newsArray count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            News *news = [_newsArray objectAtIndex:indexPath.row];
            
            if (!news.imageSmall) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:news forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    DKDebug(@"index path is %ld", (long)indexPath.row);
    DKThumbnailDownloader *iconDownloader = [_iconImageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        UIImageView *cellImg;
        
        //if we are in showcase deal, get that image, otherwise get the normal cell row image
        if (iconDownloader.indexPathInTableView.section == 0){ //if featured cell
            cellImg = (UIImageView *)[cell viewWithTag:2]; //Gets cell's icon image
        }else{
            cellImg = (UIImageView *)[cell viewWithTag:22]; //Gets cell's icon image
        }
        
        
        // Display the newly loaded image
        DKDebug(@"cell %ld", (long)iconDownloader.indexPathInTableView.row);
        cellImg.image = iconDownloader.news.imageSmall;
        
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [_iconImageDownloadsInProgress removeObjectForKey:indexPath];
    iconDownloader.delegate = nil;
    [iconDownloader release];
    
    
    [self.tableView reloadData];
    
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

//
//- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
//    CGFloat duration = animated ? 0.2 : 0.0;
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         [self selectCellAtIndexPath:indexPath];
//                     }];
//}
//
//- (void)deselectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
//    CGFloat duration = animated ? 0.2 : 0.0;
//    [UIView animateWithDuration:duration
//                     animations:^{
//                         [self deselectCellAtIndexPath:indexPath];
//                     }];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *webViewController = [[UIViewController alloc] init];
    
    News *object = _newsArray[indexPath.row];
    
    webView.delegate  = self;
    webView.scalesPageToFit = YES;
    
    [webView loadRequest:[NSURLRequest requestWithURL:
                            [NSURL URLWithString: object.webHref]]];
    
    UIBarButtonItem* performReloadBtn = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                         target:self action:@selector(performReload:)];
    
    webViewController.navigationItem.rightBarButtonItem = performReloadBtn;
    
    [webViewController.view addSubview: webView];
    
    
    
    
    [webView addSubview: activityIndicator];
    
    
    
    //[webView release];
    
    [self.navigationController pushViewController: webViewController animated:YES];
}

#pragma mark WEBVIEW Methods   


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There's an issue iwth our server. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (IBAction) performReload:(id) sender {
    [self.webView reload];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReachabilityChangedNotification object:nil];
}




- (void)dealloc {
    
	[super dealloc];
    appDelegate = nil;
    [appDelegate release];
    [firstDetailViewController release];
    [hostReach release];
    [internetReach release];
    [wifiReach release];
    webView.delegate = nil;
    [webView release];
    [activityIndicator release];
    [operation release];
    [_data release];
    [_iconImageDownloadsInProgress release];
    [_newsArray release];
    [currentSelectedNews release];
    [textColor release];
    
}


@end

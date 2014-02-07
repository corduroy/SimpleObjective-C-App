//
//  DKAPIManager.m
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import "DKAPIManager.h"
#import "News.h"

@implementation DKAPIManager

+(DKAPIManager *)sharedClient {
    static DKAPIManager *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:NEWS_FEED_URL]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}


+ (NSString*)cleanJSONWithString:(NSString*)json{
    return json; //to be deprecated later
    
}

+ (NSArray*)createListOfNews:(NSArray*)array{
    NSMutableArray* listOfNews = [[NSMutableArray alloc] init];
    
    for (int i=0; i < array.count; i++){
        News* news = [News newsWithData:[array objectAtIndex:i]];
        [listOfNews addObject:news];
        
    }
    return listOfNews;
    
}


@end

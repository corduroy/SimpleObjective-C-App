//
//  DKAPIManager.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"



@interface DKAPIManager : AFHTTPClient
+(DKAPIManager *)sharedClient;

+ (NSString*)cleanJSONWithString:(NSString*)json;
+ (NSArray*)createListOfNews:(NSArray*)array;
@end

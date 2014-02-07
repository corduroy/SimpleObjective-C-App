//
//  News.m
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import "News.h"

@implementation News

@synthesize dateLine;
@synthesize headLine;
@synthesize identifier;
@synthesize slugLine;
@synthesize thumbnailImageHref;
@synthesize tinyUrl;
@synthesize type;
@synthesize imageSmall;
@synthesize webHref;

- (void)dealloc
{
    
    [dateLine release], dateLine = nil;
    [headLine release], headLine = nil;
    [identifier release], identifier = nil;
    [slugLine release], slugLine = nil;
    [thumbnailImageHref release], thumbnailImageHref = nil;
    [tinyUrl release], tinyUrl = nil;
    [type release], type = nil;
    [webHref release], webHref = nil;
    
    [super dealloc];
    
}

+ (News *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    
    News *instance = [[[News alloc] init] autorelease];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
    
}

- (id)initWithData:(NSDictionary*)data{
    if (self = [super init]){
        self = [News newsWithData:data];
    }
    return self;
}


+ (News *)newsWithData:(NSDictionary *)data {
    News *news = [[News alloc] init];
    news.dateLine = data[@"dateLine"];
    news.headLine = data[@"headLine"];
    news.identifier = data[@"identifier"];
    news.slugLine = data[@"slugLine"];
    news.thumbnailImageHref = data[@"thumbnailImageHref"];
    news.tinyUrl = data[@"tinyUrl"];
    news.type = data[@"type"];
    news.webHref = data[@"webHref"];
    

    return news;
}





@end

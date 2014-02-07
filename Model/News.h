//
//  News.h
//  WestpacFeeder
//
//  Created by Doron Katz on 7/02/2014.
//  Copyright (c) 2014 Doron Katz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject{
    NSString *dateLine;
    NSString *headLine;
    NSNumber *identifier;
    NSString *slugLine;
    NSString *thumbnailImageHref;
    UIImage  *imageSmall;
    NSString *tinyUrl;
    NSString *type;
    NSString *webHref;
    
}

@property (nonatomic, copy) NSString *dateLine;
@property (nonatomic, copy) NSString *headLine;
@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *slugLine;
@property (nonatomic, copy) NSString *thumbnailImageHref;
@property (nonatomic, copy) NSString *tinyUrl;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *webHref;
@property (nonatomic, copy) UIImage  *imageSmall;

+ (News *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (id)initWithData:(NSDictionary*)data;
+ (News *)newsWithData:(NSDictionary *)data;


@end

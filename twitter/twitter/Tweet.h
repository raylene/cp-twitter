//
//  Tweet.h
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *truncatedTimestamp;
@property (nonatomic, strong) NSString *fullTimestamp;
@property (nonatomic, strong) NSString *originalID;

@property (nonatomic, strong) NSString *retweetCount;
@property (nonatomic, strong) NSString *favoriteCount;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *originalPoster;

@property (nonatomic, assign) BOOL isRetweet;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end

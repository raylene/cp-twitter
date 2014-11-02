//
//  Tweet.m
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "Tweet.h"

@interface Tweet()

@property (nonatomic, strong) NSDictionary *fullDictionary;

@end

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = self.originalPoster = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSDictionary *tweetDictionary = self.fullDictionary = dictionary;

        self.isRetweet = (dictionary[@"retweeted_status"] != nil);
        NSLog(@"Is RT? %hhd", self.isRetweet);
        if (self.isRetweet) {
            tweetDictionary = dictionary[@"retweeted_status"];
            NSLog(@"Retweeted status: %@", tweetDictionary[@"text"]);
        }
        
        [self setFieldsFromTweetDictionary:tweetDictionary];
    }
    return self;
}

- (void)setFieldsFromTweetDictionary:(NSDictionary *)dictionary {
    self.originalPoster = [[User alloc] initWithDictionary:dictionary[@"user"]];
    self.text = dictionary[@"text"];
    NSString *createdAtString = dictionary[@"created_at"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    self.createdAt = [formatter dateFromString:createdAtString];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end

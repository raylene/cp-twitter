//
//  Tweet.m
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "Tweet.h"

NSTimeInterval const kSecondsInHour = 3600;
NSTimeInterval const kSecondsInDay = 86400;

@interface Tweet()

@property (nonatomic, strong) NSDictionary *fullDictionary;

@end

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = self.originalPoster = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSDictionary *tweetDictionary = self.fullDictionary = dictionary;

        self.originalID = dictionary[@"id_str"];
        self.isRetweet = (dictionary[@"retweeted_status"] != nil);
        if (self.isRetweet) {
            tweetDictionary = dictionary[@"retweeted_status"];
            self.originalID = tweetDictionary[@"id_str"];
        }
        
        [self setFieldsFromTweetDictionary:tweetDictionary];
        
        self.favorited = [[dictionary objectForKey:@"favorited"] boolValue];
        self.retweeted = [[dictionary objectForKey:@"retweeted"] boolValue];
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
    
    NSTimeInterval timeInterval = [self.createdAt timeIntervalSinceNow];
    if (timeInterval > kSecondsInDay) {
        formatter.dateFormat = @"MM/dd/yyyy";
        self.truncatedTimestamp = [formatter stringFromDate:self.createdAt];
    } else {
        int hours = abs(floor(timeInterval / kSecondsInHour));
        self.truncatedTimestamp = [NSString stringWithFormat:@"%dh", hours];
    }
    formatter.dateFormat = @"MM/dd/yyyy hh:mma";
    self.fullTimestamp = [formatter stringFromDate:self.createdAt];
    
    self.retweetCount = dictionary[@"retweet_count"];
    self.favoriteCount = dictionary[@"favorite_count"];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end

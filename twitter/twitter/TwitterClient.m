//
//  TwitterClient.m
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"

// Constants
NSString * const kTwitterConsumerKey = @"wJ24qGDGjMDp31oS9cJeKf8Sq";
NSString * const kTwitterConsumerSecret = @"zSWdZDbLuoozLWolL9EVkNbKPoIHzZRL3zGYM8UMTL3EL6jTKV";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

// Notifications
NSString * const UserPostSuccessNotification = @"UserPostSuccessNotification";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    // Ensures thread-safety
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got the request token!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];

}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"got access token");
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"current user: %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            NSLog(@"user object: %@", user.name);
            [User setCurrentUser:user];
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to get current user");
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token");
    }];

}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error loading home_timeline");
        completion(nil, error);
    }];
}

- (void)postStatus:(NSString *)text replyToID:(NSString *)replyToID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:text forKey:@"status"];
    if (replyToID) {
        [params setValue:replyToID forKey:@"in_reply_to_status_id"];
    }
    NSLog(@"postStatus params: %@", params);

    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:UserPostSuccessNotification object:self userInfo:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error posting! %@", error);
        completion(nil, error);
    }];
}

- (void)favoriteStatus:(NSString *)statusID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    NSDictionary *params = @{@"id": statusID};
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error favoriting! %@", error);
        completion(nil, error);
    }];
}


- (void)retweetStatus:(NSString *)statusID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    NSString *postURL = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", statusID];
    [self POST:postURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:UserPostSuccessNotification object:self userInfo:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error retweeting! %@", error);
        completion(nil, error);
    }];
}

@end

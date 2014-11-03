//
//  TwitterClient.h
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

extern NSString * const UserPostSuccessNotification;

@interface TwitterClient : BDBOAuth1RequestOperationManager

// Singleton
+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

// GET
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

// POST
- (void)postStatus:(NSString *)text replyToID:(NSString *)replyToID completion:(void (^)(NSDictionary *response, NSError *error))completion;
- (void)favoriteStatus:(NSString *)statusID completion:(void (^)(NSDictionary *response, NSError *error))completion;
- (void)retweetStatus:(NSString *)statusID completion:(void (^)(NSDictionary *response, NSError *error))completion;

@end

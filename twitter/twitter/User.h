//
//  User.h
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

// extern -- allocated elsewhere
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject


// Basic info
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;

// Detailed info
@property (nonatomic, strong) NSString *preferredBackgroundImageUrl;
@property (nonatomic, strong) NSNumber *statusesCount;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *friendsCount;

@property (nonatomic, strong) NSDictionary *dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+(void)setCurrentUser:(User *)currentUser;
+(void)logout;

@end

//Add Accessors!
//statuses_count
//followers_count
//friends_count

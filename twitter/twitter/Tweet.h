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
@property (nonatomic, strong) User *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end

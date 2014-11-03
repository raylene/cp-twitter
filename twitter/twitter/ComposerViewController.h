//
//  ComposerViewController.h
//  twitter
//
//  Created by Raylene Yung on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposerViewController : UIViewController

@property (nonatomic, strong) Tweet *replyToTweet;

@end

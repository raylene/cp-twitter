//
//  TweetCell.h
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (weak, nonatomic) UIViewController *parentVC;

@end

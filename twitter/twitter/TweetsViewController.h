//
//  TweetsViewController.h
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsViewController : UIViewController

// If not home timeline, then use mentions timeline
// TODO: better way to do this with configs/params?
@property (nonatomic, assign) BOOL useHomeTimeline;

@end

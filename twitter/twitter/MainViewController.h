//
//  MainViewController.h
//  twitter
//
//  Created by Raylene Yung on 11/10/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) UIViewController *contentVC;
@property (nonatomic, strong) UIViewController *menuVC;

- (MainViewController*) initWithDefaultViews;

- (void)displayContentVC:(UIViewController *)contentVC;

@end

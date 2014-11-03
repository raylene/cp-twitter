//
//  LoginViewController.m
//  twitter
//
//  Created by Raylene Yung on 10/31/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()
- (IBAction)onLogin:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.title = @"Twitter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(onLogin:)];
}

- (IBAction)onLogin:(id)sender {    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
            UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            // Present error view
        }
    }];
}
@end

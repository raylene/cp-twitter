//
//  ComposerViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/1/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ComposerViewController.h"

@interface ComposerViewController ()

@end

@implementation ComposerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.title = @"Compose";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onPost:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(onPost:)];
}

- (IBAction)onPost:(id)sender {
    NSLog(@"Hit POST button");
}

- (IBAction)onCancel:(id)sender {
    NSLog(@"Hit CANCEL button");
}

@end

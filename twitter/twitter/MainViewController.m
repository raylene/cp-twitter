//
//  MainViewController.m
//  twitter
//
//  Created by Raylene Yung on 11/10/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MainViewController.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"
#import "ComposerViewController.h"

int const kMenuPeekingAmount = 60;
float const kMenuAnimationDuration = 0.3;

@interface MainViewController ()

//@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, assign) CGPoint initialOffset;

@property (nonatomic, assign) BOOL menuIsOpen;

@end

@implementation MainViewController

- (MainViewController*)initWithDefaultViews {
    self = [super init];
    MenuViewController *newMenuVC = [[MenuViewController alloc] init];
    newMenuVC.mainVC = self;
    [self setMenuVC:[[UINavigationController alloc] initWithRootViewController:newMenuVC]];
    
    [self setContentVC:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]]];
    
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.contentView];
    self.menuIsOpen = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

# pragma mark - Private helper functions

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose:)];
}

- (IBAction)onMenu:(id)sender {
    // Only open the menu it if it's not yet visible
    // TODO: check if there's a better way to check if a view is visible vs. manually tracking..
    if (self.menuIsOpen) {
        [self animateMenuClosed];
    } else {
        [self animateMenuOpen];
    }
}

- (IBAction)onCompose:(id)sender {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[ComposerViewController alloc] init]];
    nvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Custom setters

@synthesize menuVC = _menuVC;
- (void)setMenuVC:(UIViewController *)menuVC {
    _menuVC = menuVC;
    self.menuView = menuVC.view;
}

@synthesize contentVC = _contentVC;
- (void)setContentVC:(UIViewController *)contentVC {
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    _contentVC = contentVC;
    self.contentView = contentVC.view;
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.contentView addGestureRecognizer:pgr];
}

- (void)displayContentVC:(UIViewController *)contentVC {
    [self setContentVC:contentVC];
    // TODO: figure out if there's a nice way to animate this in?
    [self.view addSubview:self.contentView];
    self.menuIsOpen = NO;
}

# pragma mark - Gesture recognizers
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.initialOffset = [sender locationInView:sender.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGRect newFrame = self.view.frame;
        float newX = location.x - self.initialOffset.x;
        if (newX < 0) {
            newX = 0;
        }
        newFrame.origin.x = newX;
        sender.view.frame = newFrame;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            [self animateMenuOpen];
        } else {
            [self animateMenuClosed];
        }
    }
}

- (void)animateMenuOpen {
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        CGRect newFrame = self.view.frame;
        float maxX = (newFrame.origin.x + newFrame.size.width) - kMenuPeekingAmount;
        newFrame.origin.x = maxX;
        self.contentView.frame = newFrame;
    } completion:^(BOOL finished) {
        self.menuIsOpen = YES;
    }];
}

- (void)animateMenuClosed {
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        self.contentView.frame = self.view.frame;
    } completion:^(BOOL finished) {
        self.menuIsOpen = NO;
    }];
}

@end

//
//  TRNLoginViewController.m
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNLoginViewController.h"
#import "TRNSession.h"
#import "TRNTicketListViewController.h"
#import "TRNNetworkManager.h"
#import <TSMessage.h>
#import "TRNOrder.h"
#import "Constants.h"
#import "TRNUtils.h"
#import "TRNSplitHolderViewController.h"

@interface TRNLoginViewController () <UITextFieldDelegate, UISplitViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@end

@implementation TRNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.placeholder = NSLocalizedString(@"username", nil);
    self.passwordField.placeholder = NSLocalizedString(@"password", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary *credentials = [TRNUtils getLastUser];
    if (credentials) {
        self.usernameField.text = credentials[@"username"];
        self.passwordField.text = credentials[@"password"];
        [self login:nil];
        return;
    }
    
    if (self.usernameField.text.length>0) [self.passwordField becomeFirstResponder];
    else [self.usernameField becomeFirstResponder];
    
    if (TESTING) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self login:nil];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)login:(id)sender {
    if ([TRNUtils legacyIOS] && [TRNUtils isIPAD]) { // In order to use the new splitVC for iPhone @ iOS8
        [self performSegueWithIdentifier:@"showTicketLegacy" sender:nil];
    } else {
	    [self performSegueWithIdentifier:@"showTicketList" sender:nil];
    }
    self.passwordField.text = @"";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationVC;
    NSDictionary *credentials = @{@"username":self.usernameField.text,@"password":self.passwordField.text};
    if ([segue.destinationViewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = segue.destinationViewController;
        splitVC.delegate = self;
        splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        navigationVC = splitVC.viewControllers.firstObject;
    } else if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        navigationVC = segue.destinationViewController;
    } else if ([segue.destinationViewController isKindOfClass:[TRNSplitHolderViewController class]]) {
        TRNSplitHolderViewController *holderVC = segue.destinationViewController;
        holderVC.credentialsDictionary = credentials;
        return;
    }
    
    id viewController = navigationVC.viewControllers.firstObject;
    if ([viewController isKindOfClass:[TRNTicketListViewController class]]) {
        TRNTicketListViewController *ticketListVC = viewController;
        ticketListVC.credentialsDictionary = credentials;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.usernameField.text.length>0 && self.passwordField.text.length>0)  {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    } else {
        if (self.usernameField.text.length>0 && self.passwordField.text.length>0) {
            [self login:nil];
        } else {
            [self.usernameField becomeFirstResponder];
        }
    }
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

@end

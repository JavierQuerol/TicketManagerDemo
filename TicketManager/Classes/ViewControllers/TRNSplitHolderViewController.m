//
//  TRNSplitHolderViewController.m
//  TicketManager
//
//  Created by Javier Querol on 6/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNSplitHolderViewController.h"
#import "TRNTicketListViewController.h"

@interface TRNSplitHolderViewController () <UISplitViewControllerDelegate>

@end

@implementation TRNSplitHolderViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UISplitViewController *splitVC = segue.destinationViewController;
    UINavigationController *navVC = splitVC.viewControllers.firstObject;
    self.splitVC = splitVC;
    self.splitVC.delegate = self;
    TRNTicketListViewController *ticketsVC = navVC.viewControllers.firstObject;
    ticketsVC.credentialsDictionary = self.credentialsDictionary;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

@end

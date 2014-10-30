//
//  TRNDetailTicketViewController.m
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNDetailTicketViewController.h"
#import "UILabel+HTML.h"
#import "TRNUtils.h"
#import "TRNMapViewController.h"
#import "TRNNetworkManager.h"
#import "TRNTicketListViewController.h"
#import <TSMessage.h>

@interface TRNDetailTicketViewController () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIWebView *detailWebView;
@property (nonatomic, weak) IBOutlet UITextField *kmField;
@property (nonatomic, weak) IBOutlet UITextField *hoursField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spin;
@property (nonatomic, weak) IBOutlet UIView *placeholderView;

@property (nonatomic, weak) IBOutlet UILabel *kmLabel;
@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *changeTicketButton;
@property (nonatomic, weak) IBOutlet UITextField *commentTextField;

@property (nonatomic, weak) IBOutlet UILabel *yourWorkLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *values;

@property (nonatomic, strong) UIAlertView *rejectAlertView;
@property (nonatomic, strong) UIAlertView *changeAlertView;
@end

@implementation TRNDetailTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kmLabel.text = NSLocalizedString(@"km:", nil);
    self.hoursLabel.text = NSLocalizedString(@"hours:", nil);
    self.yourWorkLabel.text = NSLocalizedString(@"your_work", nil);
    
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [self.changeTicketButton setTitle:NSLocalizedString(@"Change Ticket", nil) forState:UIControlStateNormal];
    
    self.commentTextField.placeholder = NSLocalizedString(@"Comment:", nil);
}

- (void)setCurrentOrder:(TRNOrder *)currentOrder {
    if (!_currentOrder) {
        _currentOrder = currentOrder;
        
        NSDictionary *dataSource = [TRNUtils dictionaryFromOrder:self.currentOrder];
        self.titles = dataSource.allKeys;
        self.values = [dataSource objectsForKeys:self.titles notFoundMarker:[NSNull null]];
        
        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self.tableView reloadData];
    [self.detailWebView loadHTMLString:self.currentOrder.details baseURL:nil];
    self.tableViewHeightConstraint.constant = self.titles.count*40+15;
    
    if (self.currentOrder) self.placeholderView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = CGPointMake(0, self.tableViewHeightConstraint.constant+self.webViewHeightConstraint.constant+self.tableView.frame.origin.y+200);
    CGFloat buttonHeight = 20;
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelChangeTicket:)];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    CGPoint point = CGPointMake(0, -self.navigationController.navigationBar.frame.size.height-20);
    if ([TRNUtils isIPAD]) point = CGPointZero;
    [self.scrollView setContentOffset:point animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)cancelChangeTicket:(id)sender {
    [self.view endEditing:YES];
    [self keyboardWillBeHidden:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"RegularCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.titles[indexPath.row];
    cell.detailTextLabel.text = self.values[indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Address", nil)]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"Address", nil)]) {
        [self performSegueWithIdentifier:@"showMap" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = segue.destinationViewController;
        TRNMapViewController *mapVC = navVC.viewControllers.firstObject;
        mapVC.locationString = self.currentOrder.address;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.scrollView.scrollEnabled = NO;
    self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
}

- (IBAction)changeTicket:(id)sender {
    if (self.kmField.text.length>0 && self.hoursField.text.length>0) {
        self.changeAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you really want to set this ticket solved?", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [self.changeAlertView show];
    } else {
        [TSMessage showNotificationInViewController:self title:NSLocalizedString(@"Missing fields", nil) subtitle:nil type:TSMessageNotificationTypeWarning];
    }
}

- (IBAction)cancelTicket:(id)sender {
    self.rejectAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you really want to reject this ticket?", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [self.rejectAlertView show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (([textField isEqual:self.kmField] && (textField.text.length+string.length>0) && self.hoursField.text.length>0) ||
        ([textField isEqual:self.hoursField] && (textField.text.length+string.length>0) && self.kmField.text.length>0)) {
        self.changeTicketButton.enabled = YES;
    } else {
        self.changeTicketButton.enabled = NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:self.rejectAlertView] && alertView.cancelButtonIndex!=buttonIndex) {
        [self sendInfoWithSolved:NO];
    } else if ([alertView isEqual:self.changeAlertView] && alertView.cancelButtonIndex!=buttonIndex) {
        [self sendInfoWithSolved:YES];
    }
}

- (void)sendInfoWithSolved:(BOOL)solved {
    NSString *status = @"rejected";
    CGFloat km = 0;
    CGFloat hours = 0;
    NSString *comment = @"";
    NSString *notificationMessage = NSLocalizedString(@"Ticket canceled", nil);
    
    if (solved) {
        status = @"solved";
        km = [TRNUtils floatFromWeirdString:self.kmField.text];
        hours = [TRNUtils floatFromWeirdString:self.hoursField.text];
        comment = self.commentTextField.text;
        notificationMessage = NSLocalizedString(@"Ticket saved", nil);
    }
    
    [self.spin setHidden:NO];
    [self.spin startAnimating];
    [TRNNetworkManager changeTicketWithLang:self.currentSession.lang
                               deviceTypeId:self.currentSession.deviceTypeId
                                     userId:self.currentSession.userId
                                   secureId:self.currentSession.secureId
                                         km:km
                                      hours:hours
                                   ticketId:self.currentOrder.identifier
                                     status:status
                                    comment:comment
                                    success:^{
                                        [self.spin stopAnimating];
                                        [TSMessage showNotificationInViewController:self title:notificationMessage subtitle:nil type:TSMessageNotificationTypeSuccess];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    } error:^(NSError *error) {
                                        [self.spin stopAnimating];
                                        [TSMessage showNotificationInViewController:self title:NSLocalizedString(@"Error", nil) subtitle:error.localizedDescription type:TSMessageNotificationTypeError];
                                    }];
}

@end

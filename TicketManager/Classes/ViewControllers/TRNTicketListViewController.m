//
//  TRNTicketListViewController.m
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNTicketListViewController.h"
#import "TRNOrder.h"
#import "TRNDetailTicketViewController.h"
#import "TRNUtils.h"
#import "TRNNetworkManager.h"
#import <TSMessage.h>
#import "Constants.h"
#import "NSDate+Relative.h"

@interface TRNTicketListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spin;

@property (nonatomic, weak) IBOutlet UILabel *namePlaceholderLabel;
@property (nonatomic, strong) UISegmentedControl *dayFilterControl;

@property (nonatomic, strong) TRNSession *session;
@end

@implementation TRNTicketListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.namePlaceholderLabel.text = NSLocalizedString(@"Name:", nil);
    
    self.dayFilterControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"All", nil),
                                                                        NSLocalizedString(@"Today", nil),
                                                                        NSLocalizedString(@"Tomorrow", nil),
                                                                        NSLocalizedString(@"7 days", nil)]];
    
    [self.dayFilterControl addTarget:self action:@selector(filterTable:) forControlEvents:UIControlEventValueChanged];
    self.dayFilterControl.selectedSegmentIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.spin startAnimating];
    if (TESTING) {
        self.session = [TRNSession mocSession];
        [self.spin stopAnimating];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.session.name,self.session.lastName];
        [self.tableView reloadData];
    } else {
        [self reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)filterTable:(id)sender {
    [self.tableView reloadData];
}

- (IBAction)endSession:(id)sender {
    [TRNUtils deleteLastUser];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = tableView.backgroundColor;
    view.frame = CGRectMake(0, 0, tableView.frame.size.width, 60);
    
    UILabel *titleHeader = [UILabel new];
    titleHeader.text = NSLocalizedString(@"Current Tickets", nil);
    titleHeader.frame = CGRectMake(10, 0, view.frame.size.width-20, 20);
    [view addSubview:titleHeader];
    
    self.dayFilterControl.frame = CGRectMake(10, titleHeader.frame.size.height+5, view.frame.size.width-20, 30);
    [view addSubview:self.dayFilterControl];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self itemsFilteredArray:self.session.orders selectedIndex:self.dayFilterControl.selectedSegmentIndex].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orders = [self itemsFilteredArray:self.session.orders selectedIndex:self.dayFilterControl.selectedSegmentIndex];
    TRNOrder *order = orders[indexPath.row];
    cell.textLabel.text = order.title;
    cell.detailTextLabel.text = NSLocalizedString(order.status,nil);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *orders = [self itemsFilteredArray:self.session.orders selectedIndex:self.dayFilterControl.selectedSegmentIndex];
    TRNDetailTicketViewController *detailVC = segue.destinationViewController;
    detailVC.title = [self titleForSelectedRow:self.tableView.indexPathForSelectedRow];
    detailVC.currentOrder = orders[self.tableView.indexPathForSelectedRow.row];
    detailVC.currentSession = self.session;
}

- (NSString *)titleForSelectedRow:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.textLabel.text;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password :(void (^)(TRNSession *session))block {
    NSString *lang = @"de";
    NSString *deviceTypeId = [TRNUtils deviceTypeId];
    [TRNNetworkManager loginAndTicketsWithLang:lang deviceTypeId:deviceTypeId username:username password:password success:^(TRNSession *session) {
        block(session);
    } error:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:^{
            UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
            [TSMessage showNotificationInViewController:window.rootViewController title:NSLocalizedString(@"Error", nil) subtitle:error.localizedDescription type:TSMessageNotificationTypeError];
            block(nil);
        }];
    }];
}

- (void)reloadData {
    [self loginWithUsername:self.credentialsDictionary[@"username"] password:self.credentialsDictionary[@"password"] :^(TRNSession *session) {
        [self.spin stopAnimating];
        if (session) {
            self.session = session;
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.session.name,self.session.lastName];
            [self.tableView reloadData];
            [TRNUtils saveUserName:self.credentialsDictionary[@"username"] andPassword:self.credentialsDictionary[@"password"]];
        } else {
            [TRNUtils deleteLastUser];
        }
    }];
}

- (NSArray *)itemsFilteredArray:(NSArray *)objects selectedIndex:(NSInteger)index {
    NSDate *filterDate;
    switch (index) {
        case 0:
            return objects;
            break;
        case 1:
            filterDate = [NSDate jaq_today];
            break;
        case 2:
            filterDate = [NSDate jaq_tomorrow];
            break;
        case 3:
            filterDate = [NSDate jaq_7days];
            break;
        default:
            return objects;
            break;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creationDate <= %@ AND creationDate >= %@",filterDate,[NSDate date]];
    return [objects filteredArrayUsingPredicate:predicate];
}

@end

//
//  TRNTicketListViewController.h
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRNSession.h"

@interface TRNTicketListViewController : UIViewController

@property (nonatomic, strong) NSDictionary *credentialsDictionary;

- (void)reloadData;

@end

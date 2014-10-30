//
//  TRNSplitHolderViewController.h
//  TicketManager
//
//  Created by Javier Querol on 6/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNSplitHolderViewController : UIViewController

@property (nonatomic, strong) UISplitViewController *splitVC;
@property (nonatomic, strong) NSDictionary *credentialsDictionary;

@end

//
//  TRNDetailTicketViewController.h
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRNOrder.h"
#import "TRNSession.h"

@interface TRNDetailTicketViewController : UIViewController

@property (nonatomic, strong) TRNOrder *currentOrder;
@property (nonatomic, strong) TRNSession *currentSession;

@end

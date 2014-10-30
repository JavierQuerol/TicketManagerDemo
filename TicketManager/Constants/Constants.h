//
//  Constants.h
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#define TESTING 0
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#warning MISSING URL

#define URL_LOGIN_AND_TICKETS @""
#define URL_CHANGETICKET @""

static const NSInteger SECONDS_IN_WEEK = 604800;
static const NSInteger SECONDS_IN_DAY = 86400;

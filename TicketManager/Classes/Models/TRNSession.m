//
//  TRNSession.m
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNSession.h"
#import "TRNUtils.h"
#import "Constants.h"

@implementation TRNSession

+ (TRNSession *)parseWithDic:(NSDictionary *)dic {
    TRNSession *session = [TRNSession new];
    
    if(dic[@"userid"]) session.userId = dic[@"userid"];
    else return nil;
    if(dic[@"vorname"]) session.name = dic[@"vorname"];
    else return nil;
    if(dic[@"familienname"]) session.lastName = dic[@"familienname"];
    else return nil;
    if(dic[@"secureid"]) session.secureId = dic[@"secureid"];
    else return nil;
    if(dic[@"lang"]) session.lang = dic[@"lang"];
    else return nil;
    
    session.deviceTypeId = [TRNUtils deviceTypeId];
    
    return session;
}

+ (TRNSession *)mocSession {
    TRNSession *session = [TRNSession new];
    session.name = @"John";
    session.deviceTypeId = [TRNUtils deviceTypeId];
    session.userId = @"123";
    session.secureId = @"123";
    session.status = SessionStatusSolved;
    session.lang = @"de";
    session.lastName = @"Doe";
    
    TRNOrder *order = [TRNOrder new];
    order.identifier = 1;
    order.creationDate = [[NSDate date] dateByAddingTimeInterval:SECONDS_IN_DAY*2];
    order.hours = 10.5;
    order.kilometers = 2.5;
    order.title = @"Order test0";
    order.address = @"Test address";
    order.details = @"<b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i>";
    order.status = @"new";
    
    TRNOrder *order1 = [TRNOrder new];
    order1.identifier = 1;
    order1.creationDate = [[NSDate date] dateByAddingTimeInterval:SECONDS_IN_DAY*5];
    order1.hours = 10.5;
    order1.kilometers = 2.5;
    order1.title = @"Order test1";
    order1.address = @"Test address";
    order1.details = @"<b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i>";
    order1.status = @"new";
    
    TRNOrder *order2 = [TRNOrder new];
    order2.identifier = 1;
    order2.creationDate = [[NSDate date] dateByAddingTimeInterval:SECONDS_IN_DAY];
    order2.hours = 10.5;
    order2.kilometers = 2.5;
    order2.title = @"Order test2";
    order2.address = @"Test address";
    order2.details = @"<b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i>";
    order2.status = @"new";
    
    TRNOrder *order3 = [TRNOrder new];
    order3.identifier = 1;
    order3.creationDate = [[NSDate date] dateByAddingTimeInterval:SECONDS_IN_DAY*14];
    order3.hours = 10.5;
    order3.kilometers = 2.5;
    order3.title = @"Order test3";
    order3.address = @"Test address";
    order3.details = @"<b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i>";
    order3.status = @"new";
    
    TRNOrder *order4 = [TRNOrder new];
    order4.identifier = 1;
    order4.creationDate = [[NSDate date] dateByAddingTimeInterval:-SECONDS_IN_DAY*2];
    order4.hours = 10.5;
    order4.kilometers = 2.5;
    order4.title = @"Order test4";
    order4.address = @"Test address";
    order4.details = @"<b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i><br /><b>This is a test</b> <i>test</i>";
    order4.status = @"new";
    
    session.orders = @[order,order1,order2,order3,order4];
    return session;
}

@end

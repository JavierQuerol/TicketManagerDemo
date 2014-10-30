//
//  TRNOrder.m
//  TicketManager
//
//  Created by Javier Querol on 02/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNOrder.h"

static NSDateFormatter *formatter = nil;

@implementation TRNOrder

+ (TRNOrder *)parseWithDic:(NSDictionary *)dic {
    TRNOrder *order = [TRNOrder new];
    
    if (dic[@"id"]) order.identifier = [dic[@"id"] integerValue];
    else return nil;
    
    if (dic[@"created"]) {
        order.creationDate = [[[self class] dateFormatter] dateFromString:dic[@"created"]];
    }
    else return nil;
    
    if (dic[@"hours"]) order.hours = [dic[@"hours"] floatValue];
    else order.hours = 0;
    
    if (dic[@"km"]) order.kilometers = [dic[@"km"] floatValue];
    else order.kilometers = 0;
    
    if (dic[@"title"]) order.title = dic[@"title"];
    if (dic[@"details"]) order.details = dic[@"details"];
    if (dic[@"address"]) order.address = dic[@"address"];
    if (dic[@"status"]) order.status = dic[@"status"];
    
    return order;
}

+ (NSDateFormatter *)dateFormatter {
    if (!formatter) {
        formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    }
    return formatter;
}

@end

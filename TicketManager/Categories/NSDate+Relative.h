//
//  NSDate+Relative.h
//  TicketManager
//
//  Created by Javier Querol on 30/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Relative)

+ (NSDate *)jaq_tomorrow;
+ (NSDate *)jaq_today;
+ (NSDate *)jaq_7days;

@end

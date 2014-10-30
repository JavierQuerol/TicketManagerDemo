//
//  NSDate+Relative.m
//  TicketManager
//
//  Created by Javier Querol on 30/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "NSDate+Relative.h"
#import "Constants.h"

@implementation NSDate (Relative)

+ (NSDate *)jaq_dateOfToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    return [calendar dateFromComponents:dateComps];
}

+ (NSDate *)jaq_beginingToday {
    return [NSDate jaq_dateOfToday];
}

+ (NSDate *)jaq_tomorrow {
    return [[NSDate jaq_dateOfToday] dateByAddingTimeInterval:SECONDS_IN_DAY*2];
}

+ (NSDate *)jaq_today {
    return [[NSDate jaq_dateOfToday] dateByAddingTimeInterval:SECONDS_IN_DAY];
}

+ (NSDate *)jaq_7days {
    return [[NSDate jaq_dateOfToday] dateByAddingTimeInterval:SECONDS_IN_WEEK];
}

@end

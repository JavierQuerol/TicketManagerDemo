//
//  TRNUtils.m
//  TicketManager
//
//  Created by Javier Querol on 02/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNUtils.h"
#import "UILabel+HTML.h"
#import "Constants.h"

@implementation TRNUtils {
    NSDateFormatter *dateFormatter;
    NSDateFormatter *timeFormatter;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    }
    return dateFormatter;
}

- (NSDateFormatter *)timeFormatter {
    if (!timeFormatter) {
        timeFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return timeFormatter;
}

+ (NSDictionary *)dictionaryFromOrder:(TRNOrder *)order {
    if (!order) return nil;
    
    NSString *date = [NSString stringWithFormat:@"%@ %@",
                      [[TRNUtils sharedInstance].dateFormatter stringFromDate:order.creationDate],
                      [[TRNUtils sharedInstance].timeFormatter stringFromDate:order.creationDate]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{NSLocalizedString(@"Title", nil):order.title}];
    [dic addEntriesFromDictionary:@{NSLocalizedString(@"Created", nil):date}];
    
    if (order.address.length>0) {
        [dic addEntriesFromDictionary:@{NSLocalizedString(@"Address", nil):order.address}];
    }
    
    return dic;
}

+ (BOOL)legacyIOS {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) return YES;
    return NO;
}

+ (BOOL)isIPAD {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) return YES;
    return NO;
}

+ (CGFloat)floatFromWeirdString:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
    return [string floatValue];
}

+ (NSString *)deviceTypeId {
    NSString *deviceTypeId = @"1";
    if ([TRNUtils isIPAD]) deviceTypeId = @"2";
    return deviceTypeId;
}

+ (NSDictionary *)getLastUser {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"lastUser"];
}

+ (void)saveUserName:(NSString *)username andPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setValue:@{@"username":username,@"password":password} forKey:@"lastUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteLastUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

//
//  TRNUtils.h
//  TicketManager
//
//  Created by Javier Querol on 02/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRNOrder.h"
#import "TRNSession.h"

@interface TRNUtils : NSObject

+ (instancetype)sharedInstance;

+ (NSDictionary *)dictionaryFromOrder:(TRNOrder *)order;
+ (BOOL)legacyIOS;
+ (BOOL)isIPAD;
+ (CGFloat)floatFromWeirdString:(NSString *)string;
+ (NSString *)deviceTypeId;
+ (NSDictionary *)getLastUser;
+ (void)saveUserName:(NSString *)username andPassword:(NSString *)password;
+ (void)deleteLastUser;

@end

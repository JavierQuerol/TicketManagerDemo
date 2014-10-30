//
//  TRNNetworkManager.h
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "TRNSession.h"

@interface TRNNetworkManager : NSObject

+ (AFHTTPRequestOperation *)loginAndTicketsWithLang:(NSString *)lang deviceTypeId:(NSString *)deviceTypeId username:(NSString *)username password:(NSString *)password success:(void(^)(TRNSession *session))successBlock error:(void(^)(NSError *error))errorBlock;

+ (AFHTTPRequestOperation *)changeTicketWithLang:(NSString *)lang deviceTypeId:(NSString *)deviceTypeId userId:(NSString *)userId secureId:(NSString *)secureId km:(CGFloat)km hours:(CGFloat)hours ticketId:(NSInteger)ticketId status:(NSString *)status comment:(NSString *)comment success:(void(^)())successBlock error:(void(^)(NSError *error))errorBlock;

@end

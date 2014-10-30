//
//  TRNNetworkManager.m
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNNetworkManager.h"
#import "Constants.h"
#import <RaptureXML/RXMLElement.h>
#import "TRNOrder.h"

@implementation TRNNetworkManager

+ (AFHTTPRequestOperation *)loginAndTicketsWithLang:(NSString *)lang deviceTypeId:(NSString *)deviceTypeId username:(NSString *)username password:(NSString *)password
                                            success:(void(^)(TRNSession *session))successBlock
                                              error:(void(^)(NSError *error))errorBlock {
    if (lang.length>0 && deviceTypeId.length>0 && username.length>0 && password.length>0) {
        
        NSDictionary *params = @{@"lang":lang,
                                 @"devicetypeid":deviceTypeId,
                                 @"u":username,
                                 @"p":password};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        return [manager GET:URL_LOGIN_AND_TICKETS parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
            RXMLElement *login = [rootXML child:@"login"];
            NSDictionary *userInfo = [self dicFromXMLKeys:@[@"userid",@"vorname",@"familienname",@"secureid",@"lang"] element:login];
            TRNSession *session = [TRNSession parseWithDic:userInfo];
            
            if (session) {
                NSMutableArray *orders = [NSMutableArray array];
                [rootXML iterate:@"orders.order" usingBlock: ^(RXMLElement *order) {
                    NSDictionary *orderDic = [self dicFromXMLKeys:@[@"id",@"created",@"hours",@"km",@"title",@"details",@"status",@"address"] element:order];
                    TRNOrder *userOrder = [TRNOrder parseWithDic:orderDic];
                    if (userOrder) [orders addObject:userOrder];
                }];
                session.orders = orders;
                successBlock(session);
            } else {
                errorBlock([self somethingFailedWithElement:rootXML]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(error);
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"TRNParsingErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Missing fields"}];
        errorBlock(error);
        return nil;
    }
}

+ (AFHTTPRequestOperation *)changeTicketWithLang:(NSString *)lang deviceTypeId:(NSString *)deviceTypeId userId:(NSString *)userId secureId:(NSString *)secureId km:(CGFloat)km hours:(CGFloat)hours ticketId:(NSInteger)ticketId status:(NSString *)status comment:(NSString *)comment success:(void(^)())successBlock error:(void(^)(NSError *error))errorBlock {
    if (lang.length>0 && deviceTypeId.length>0 && userId.length>0 && secureId.length>0 && ticketId>0 && status.length>0) {
        
        NSDictionary *params = @{@"lang":lang,
                                 @"devicetypeid":deviceTypeId,
                                 @"userid":userId,
                                 @"secureid":secureId,
                                 @"km":@(km),
                                 @"hours":@(hours),
                                 @"ticketid":@(ticketId),
                                 @"status":status,
                                 @"comment":comment};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        return [manager GET:URL_CHANGETICKET parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
            RXMLElement *statusmsg = [rootXML child:@"statusmsg"];
            if (statusmsg) {
                RXMLElement *errormsg = [statusmsg child:@"errormsg"];
                if (errormsg) {
                    NSError *error = [NSError errorWithDomain:@"TRNServiceFailed" code:-1 userInfo:@{NSLocalizedDescriptionKey:errormsg.text}];
                    errorBlock(error);
                } else {
		            successBlock();
                }
            } else {
                errorBlock([self somethingFailedWithElement:statusmsg]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(error);
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"TRNParsingErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Missing fields"}];
        errorBlock(error);
        return nil;
    }
}

+ (NSError *)somethingFailedWithElement:(RXMLElement *)element {
    NSError *error;
    if ([[[element child:@"status"].text lowercaseString] isEqualToString:@"error"]) {
        error = [NSError errorWithDomain:@"TRNParsingErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:[element child:@"message"].text}];
    } else {
        error = [NSError errorWithDomain:@"TRNParsingErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Error parsing XML"}];
    }
    return error;
}

+ (NSDictionary *)dicFromText:(NSString *)string element:(RXMLElement *)element {
    RXMLElement *result = [element child:string];
    if (result && result.text) {
        return @{string:result.text};
    } else {
        return [NSDictionary dictionary];
    }
}

+ (NSDictionary *)dicFromXMLKeys:(NSArray *)array element:(RXMLElement *)element {
    if (!element) return nil;
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    for (NSString *string in array) {
        [mutableDic addEntriesFromDictionary:[self dicFromText:string element:element]];
    }
    return mutableDic;
}

@end

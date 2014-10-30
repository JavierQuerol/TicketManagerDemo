//
//  TRNSession.h
//  TicketManager
//
//  Created by Javier Querol on 01/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNSession : NSObject

typedef NS_ENUM(NSUInteger, SessionStatus) {
    SessionStatusNone = 0,
    SessionStatusSolved = 1
};

@property (nonatomic, strong) NSString *deviceTypeId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *secureId;
@property (nonatomic, assign) SessionStatus status;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSArray *orders;

+ (TRNSession *)parseWithDic:(NSDictionary *)dic;

+ (TRNSession *)mocSession;

@end

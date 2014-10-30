//
//  TRNOrder.h
//  TicketManager
//
//  Created by Javier Querol on 02/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNOrder : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, assign) CGFloat hours;
@property (nonatomic, assign) CGFloat kilometers;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *status;

+ (TRNOrder *)parseWithDic:(NSDictionary *)dic;

@end

//
//  UILabel+HTML.m
//  TicketManager
//
//  Created by Javier Querol on 02/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "UILabel+HTML.h"

@implementation UILabel (HTML)

- (void)jaq_setHTMLFromString:(NSString *)string {
    self.attributedText = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                documentAttributes:nil
                                                             error:nil];
}


@end

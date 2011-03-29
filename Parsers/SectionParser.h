//
//  SectionParser.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "Board.h"
#import "BBSParserDelegate.h"

extern NSString * kSection;

@interface SectionParser : NSOperation <NSXMLParserDelegate> {
    NSURL * url;
    NSMutableArray * boardList;
    Category * category;
    Board * board;
    BOOL isCategory;
    id<BBSParserDelegate> delegate;
    BOOL errorOccured;
}

@property (nonatomic, retain) id delegate;

- (id) initWithURL:(NSURL *)_url;

@end

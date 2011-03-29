//
//  SectionParser.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSParserDelegate.h"
#import "Top10Item.h"

extern NSString * kTop10;


@interface Top10Parser : NSOperation <NSXMLParserDelegate> {
    NSURL * url;
    NSMutableArray * top10List;
    id<BBSParserDelegate> delegate;
    Top10Item * currentItem;
    NSMutableString * buffer;
}

@property (nonatomic, retain) id delegate;

- (id) initWithURL:(NSURL *)_url;

@end

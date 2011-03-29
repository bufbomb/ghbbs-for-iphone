//
//  PostParser.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/13/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Board.h"
#import "ViewMode.h"
#import "BBSParserDelegate.h"
#import "ErrorType.h"

extern NSString * kPost;
extern NSString * kBid;

@interface PostParser : NSOperation <NSXMLParserDelegate> {
    NSURL * url;
    NSMutableString * buffer;
    BOOL isAppending;
    Post * currentPost;
    NSMutableArray * posts;
    id<BBSParserDelegate> delegate;
    BOOL errorOccured;
    ErrorType errorType;
    
    NSString * bid;
}

- (id) initWithURL:(NSURL *)_url;
//- (id) initWithBid:(NSString *)_bid Pid:(NSString *)_pid Mode:(ViewMode)viewMode;

@property (nonatomic, retain) id<BBSParserDelegate> delegate;
@end

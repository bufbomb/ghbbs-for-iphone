//
//  BoardParser.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "Post.h"
#import "ViewMode.h"
#import "BBSParserDelegate.h"

extern NSString * kPost;
extern NSString * kMode;
extern NSString * kStickPost;
extern NSString * kStart;
extern NSString * kBid;

@interface BoardParser : NSOperation <NSXMLParserDelegate> {
    NSURL * url;
    ViewMode viewMode;
    NSMutableArray * postList;
    NSMutableArray * stickPostList;
    Post * currentPost;
    NSMutableString * buffer;
    id<BBSParserDelegate> delegate;
    int start;
    NSString * bid;
    BOOL errorOccured;
}

//- (id) initWithBoard:(Board *)_board ViewMode:(ViewMode)_viewMode;

- (id) initWithURL:(NSURL *)_url Mode:(ViewMode)_mode;

@property (nonatomic, retain) id<BBSParserDelegate> delegate;
@end

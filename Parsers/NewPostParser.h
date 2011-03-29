//
//  NewPostParser.h
//  ghbbs
//
//  Created by Chenqun Hang on 12/2/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSParserDelegate.h"
#import "BoardPermission.h"

extern NSString * kBoardPermission;
extern NSString * kTitle;
extern NSString * kPostContent;


@interface NewPostParser : NSOperation <NSXMLParserDelegate> {
    NSURL * url;
    NSMutableString * buffer;
    BOOL isAppending;
    id<BBSParserDelegate> delegate;
    
    BoardPermission * boardPermission;
    NSString * title;
    NSString * postContent;
    BOOL errorOccured;
    ErrorType errorType;
    
    

}

@property (nonatomic, retain) id delegate;

- (id) initWithURL:(NSURL *)_url;


@end

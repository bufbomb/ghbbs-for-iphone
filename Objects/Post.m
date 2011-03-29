//
//  Post.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Post.h"


@implementation Post
@synthesize title = _title;
@synthesize owner = _owner;
@synthesize time = _time;
@synthesize content = _content;
@synthesize isStick = _isStick;
@synthesize pid = _pid;
@synthesize mark = _mark;
- (id) init
{
    if (self = [super init])
    {
        self.isStick = NO;
    }
    return self;
}

- (void) dealloc
{
    [_title release];
    [_owner release];
    [_content release];
    [super dealloc];
}

@end

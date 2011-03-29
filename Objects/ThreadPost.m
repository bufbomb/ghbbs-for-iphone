//
//  ThreadPost.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/20/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "ThreadPost.h"


@implementation ThreadPost

- (id) init
{
    if (self = [super init])
    {
        posts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [posts release];
    [super dealloc];
}
@end

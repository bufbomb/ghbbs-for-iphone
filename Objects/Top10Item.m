//
//  Top10Item.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Top10Item.h"


@implementation Top10Item
@synthesize boardName = _boardName;
@synthesize postTitle = _postTitle;
@synthesize owner = _owner;
@synthesize pid = _pid;
@synthesize count = _count;

- (id) initWithBoardName:(NSString *)name Owner:(NSString *)owner Pid:(NSString *)pid Count:(int)count
{
    if (self = [super init])
    {
        self.boardName = name;
        self.owner = owner;
        self.pid = pid;
        self.count = count;
    }
    return self;
}
@end

//
//  Category.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Category.h"


@implementation Category
@synthesize name = _name;
@synthesize cid = _cid;

- (id) initWithName:(NSString *)name Cid:(NSString *) cid
{
    if(self = [super init])
    {
        self.name = name;
        self.cid = cid;
        boardList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addBoard:(Board *)board
{
    [boardList addObject: board];
}

- (void) addBoards:(NSArray *)boards
{
    [boardList addObjectsFromArray:boards];
}

- (void) removeAllBoards
{
    [boardList removeAllObjects];
}

- (int) numberOfBoards
{
    return [boardList count];
}

- (Board *) boardAtIndex:(int)index
{
    if(index >= [boardList count])
    {
        return nil;
    }
    return (Board *)[boardList objectAtIndex:index];
}

- (void) dealloc
{
    [_name release];
    [_cid release];
    [boardList release];
    [super dealloc];
}
@end

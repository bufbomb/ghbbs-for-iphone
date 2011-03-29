//
//  Board.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Board.h"


@implementation Board
@synthesize name = _name;
@synthesize desc = _desc;
@synthesize bid = _bid;
@synthesize total = _total;
@synthesize isZone;

- (id) initWithName:(NSString *) name Desc:(NSString *) desc Dir:(int) dir
{
    if (self = [super init])
    {
        _name = [name copy];
        _desc = [desc copy];
        self.isZone = dir > 0;
        subBoardList = [[NSMutableArray alloc] init];
        BMList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addSubBoards:(NSArray *)subBoardArray
{
    assert(subBoardArray != nil);
    assert(isZone == YES);
    [subBoardList addObjectsFromArray:subBoardArray];
}

- (void) addBMs: (NSArray *)bms
{
    assert(bms != nil);
    assert(isZone == NO);
    [BMList addObjectsFromArray:bms];
}

- (NSArray *) getBMs
{
    assert(BMList != nil);
    if (isZone) 
    {
        return nil;
    }
    else 
    {
        return [NSArray arrayWithArray:BMList];
    }
}

- (void) removeAllSubBoards
{
    assert(isZone == YES);
    [subBoardList removeAllObjects];
}

- (int) numberOfSubBoards
{
    assert(subBoardList != nil);
    assert(isZone == YES);
    return [subBoardList count];
}


- (Board *) subBoardAtIndex:(int)index
{
    assert(isZone == YES);
    if (index>= [subBoardList count]) 
    {
        return nil;
    }
    return (Board *)[subBoardList objectAtIndex:index];
}

- (NSComparisonResult) compare:(Board *)anotherBoard
{
    assert(anotherBoard != nil);
    if (self.isZone != anotherBoard.isZone) 
    {
        return self.isZone ? NSOrderedDescending : NSOrderedAscending;
    }
    else 
    {
        return [self.name compare:anotherBoard.name];
    }
}

- (void) dealloc
{
    [subBoardList release];
    [BMList release];
    [_name release];
    [_desc release];
    [_bid release];
    [super dealloc];
}
@end

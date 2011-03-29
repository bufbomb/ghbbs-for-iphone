//
//  CategoryDataSource.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "CategoryDataSource.h"
#import "CategoryParser.h"

static CategoryDataSource * sharedInstance = nil;
NSString * kCategoryUpdated = @"CategoryUpdated.";

@implementation CategoryDataSource
+ (CategoryDataSource *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[CategoryDataSource alloc] init];
        }
        return sharedInstance;
    }
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id) init
{
    if(self = [super init])
    {
        data = [[NSMutableArray alloc] init];
        favBoards = [[NSMutableArray alloc] init];
        /*[[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addCategoryObject:)
                                                     name:kAddCategoryNotif
                                                   object:nil];*/
    }
    return self;
}

- (void) addCategories:(NSArray *)categories
{
    [data addObjectsFromArray:categories];
}

- (void) removeCategories
{
    [data removeAllObjects];
}

- (int) numberOfCategories
{
    return [data count];
}

- (Category *) categoryAtIndex:(int) index
{
    if (index >= [data count])
    {
        return nil;
    }
    else 
    {
        return (Category *)[data objectAtIndex:index];
    }
}

- (void) addFavs:(NSArray *)favs
{
    [favBoards addObjectsFromArray:favs];
}

- (void) removeFavs
{
    [favBoards removeAllObjects];
}

- (int) numberOfFavs
{
    return [favBoards count];
}

- (NSString *)favAtIndex:(int)index
{
    if (index >= [favBoards count])
    {
        return nil;
    }
    else
    {
        return (NSString *)[favBoards objectAtIndex:index];
    }

}


#pragma mark Singleton methods
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

- (void) dealloc
{
    [data release];
    [super dealloc];
}

@end

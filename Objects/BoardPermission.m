//
//  BoardPermission.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/2/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "BoardPermission.h"


@implementation BoardPermission
@synthesize edit = _edit;
@synthesize att = _att;
@synthesize anony = _anony;

- (id) init
{
    if (self = [super init])
    {
        _edit = NO;
        _att = NO;
        _anony = NO;
    }
    return self;
}
@end

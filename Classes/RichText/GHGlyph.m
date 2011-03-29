//
//  GHGlyph.m
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "GHGlyph.h"


@implementation GHGlyph
@synthesize content = _content;
- (void) dealloc
{
	[_content release];
	[super dealloc];
}

@end

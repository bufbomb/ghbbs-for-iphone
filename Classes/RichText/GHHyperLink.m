//
//  GHHyperLink.m
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "GHHyperLink.h"


@implementation GHHyperLink
@synthesize url = _url;
- (id) initWithUrl:(NSURL *)urlstr
{
	if (self = [super init]) 
	{
		_content = [[urlstr absoluteString] copy];
		_url = [urlstr copy];
	}
	return self;
}

- (void) draw
{
	NSAssert(_content != nil, @"content shouldn't be nil.");
	[_content drawInRect:_rect withFont:[UIFont systemFontOfSize:14.0f]];
}
		
- (void) dealloc
{
	[_url release];
	[super dealloc];
}

@end

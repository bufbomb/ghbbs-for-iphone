//
//  GHPrintableGlyph.m
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "GHPrintableGlyph.h"


@implementation GHPrintableGlyph
@synthesize rect = _rect;
@synthesize color = _color;
- (void) draw
{
	NSAssert(_content != nil, @"Content shouldn't be nil");
	NSAssert(_color != nil, @"Color not nil");
	//[_content drawInRect:_rect withFont:[UIFont systemFontOfSize:14.0f]];
	if (_color != nil) 
	{
		UIGraphicsPushContext(UIGraphicsGetCurrentContext());
		[_color set];
		UIGraphicsPopContext();
	}
	[_content drawAtPoint:_rect.origin withFont:[UIFont systemFontOfSize:14.0f]];
}


- (void) dealloc
{
	[_color release];
	[super dealloc];
}

@end

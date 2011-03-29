//
//  GHDocument.m
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "GHDocument.h"
#import "GHText.h"
#import "GHHyperLink.h"
#import "GHLinebreak.h"
#import "GHChangeColor.h"
#import "GHGlyphParser.h"
#import "GHImage.h"


@interface GHDocument()

@end


@implementation GHDocument
@synthesize rect = _rect;

- (id) initWithShowPicture:(BOOL)isShownPic needAnsiColor:(BOOL)needAnsiColor
{
	if (self = [super init]) 
	{
		_glyphs = [[NSMutableArray alloc] init];
		_isShownPic = isShownPic;
		_needAnsiColor = needAnsiColor;

	}
	return self;
}

- (void) draw
{
	BOOL isComment = NO;
	

	for (GHGlyph * glyph in _glyphs) 
	{
		if ([glyph isKindOfClass:[GHText class]]) 
		{
			GHText * ghtext = (GHText *)glyph;
			NSLog(@"|%@|", ghtext.content);

			if ([ghtext.content hasPrefix:@":"]) 
			{
				isComment = YES;
			}
			
			if (isComment) 
			{
				ghtext.color = [UIColor grayColor];
			}

			[ghtext draw];
		}
		else if ([glyph isKindOfClass:[GHImage class]])
		{
			GHImage * imageLink = (GHImage *)glyph;
			[imageLink draw];
		}
		else if ([glyph isKindOfClass:[GHHyperLink class]])
		{
			GHHyperLink * ghhyperlink = (GHHyperLink *)glyph;
			[ghhyperlink draw];
		}
		else if ([glyph isKindOfClass:[GHLinebreak class]])
		{
			isComment = NO;
		}
		else if ([glyph isKindOfClass:[GHChangeColor class]])
		{
			;
		}
		else
		{
			assert(NO);
		}

	}
}

- (void) formatWithText:(NSString *)allText
{
	NSAssert(allText != nil, @"Text shouldn't be nil");
	NSAssert(_glyphs != nil, @"Glyph array should be allocated.");
	[_glyphs removeAllObjects];

	_rect.origin.x = 0.0f;
	_rect.origin.y = 0.0f;
	_rect.size.width = 320.0f;
    //float _height = 0.0f;
	
	GHContentParser * parser = [[GHContentParser alloc] initWithContent:allText ShowPicture:_isShownPic NeedAnsiColor:_needAnsiColor];

	while (YES) {
		GHGlyph * item = [parser nextItem];
		
		if (item == nil) {
			break;
		}
		
		if ([item isKindOfClass:[GHPrintableGlyph class]]) 
		{
			[_glyphs addObject:item];
		}
		else if ([item isMemberOfClass:[GHChangeColor class]])
		{
//			[_glyphs addObject:item];
		}
		else if ([item isMemberOfClass:[GHLinebreak class]])
		{
			[_glyphs addObject:item];
		}
		else
		{
			NSAssert(NO, @"error");
		}
	}
	
	_rect.size.height = [parser getOverallHeight];
}

- (void) dealloc
{
	[_glyphs release];
	[super dealloc];
}
@end

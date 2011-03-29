//
//  GHContentParser.m
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "GHGlyphParser.h"
#import "GHPrintableGlyph.h"
#import "GHText.h"
#import "GHHyperLink.h"
#import "GHChangeColor.h"
#import "GHLinebreak.h"
#import "GHImage.h"
#import "RegexKitLite.h"

@interface GHContentParser()
- (void) prepareGlyphsBuffer;
- (NSArray *)splitToPrintableGlyphsWithGlyph:(GHGlyph *)glyph;
- (GHGlyph *) generateGlyphWithContent:(NSString *)content;
- (int) lengthOfString:(NSString *)string WithInWidth:(float)width;
@end


@implementation GHContentParser
- (id) initWithContent:(NSString *)content ShowPicture:(BOOL)isShownPic NeedAnsiColor:(BOOL)needAnsiColor;
{
	if (self = [super init])
	{
		_content = [content copy];
		_isShownPic = isShownPic;
		_needAnsiColor = needAnsiColor;
		bufferedItems = [[NSMutableArray alloc] init];
		index = 0l;
		startPos = 0.0;
		currentColor = [UIColor blackColor];
		NSString * urlRegex = @"https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
		NSString * ansiControl = @"\\>1b\\[.*?[abcdhsukfm]";
		NSString * linebreak = @"\\n";
		_glyphRegex = [[NSString alloc] initWithFormat:@"%@|%@|%@", urlRegex,  ansiControl, linebreak];
		_colorCodeRegex = [[NSString alloc] initWithString:@"3[0-7]"];
		overallHeight = 0.0;
	}
	return self;
}

- (GHGlyph *) nextItem
{
	NSAssert(_content != nil, @"_content shouldn't be nil.");
	if ([bufferedItems count] == 0) 
	{
		[self prepareGlyphsBuffer];
	}
	
	if ([bufferedItems count] == 0) 
	{
		return nil;
	}
	else 
	{
		GHGlyph * result = [(GHGlyph *)[bufferedItems objectAtIndex:0] retain];
		[bufferedItems removeObjectAtIndex:0];
		return [result autorelease];
	}
}

- (void) prepareGlyphsBuffer;
{
	NSAssert([bufferedItems count] == 0, @"There should be no buffered item.");
	[bufferedItems removeAllObjects];
	if (_content == nil || index >= [_content length]) 
	{
		return;
	}
	
	NSRange matchRange = NSMakeRange(NSNotFound, 0);
	NSRange searchRange = NSMakeRange(index, [_content length] - index);
	matchRange = [_content rangeOfRegex:_glyphRegex inRange:searchRange];
	GHGlyph * plainGlyph = nil;
	GHGlyph * matchedGlyph = nil;
	
	if (matchRange.location != NSNotFound) 
	{
		/* If find the hyperlink or change color pattern in the middle of the content */
		if (index != matchRange.location) 
		{
			plainGlyph = [self generateGlyphWithContent:[_content substringWithRange:NSMakeRange(index, matchRange.location - index)]];
			matchedGlyph = [self generateGlyphWithContent:[_content substringWithRange:matchRange]];
		}
		else 
		{
			matchedGlyph = [self generateGlyphWithContent:[_content substringWithRange:matchRange]];
		}
		
		index = matchRange.location + matchRange.length;
		
		NSAssert(index <= [_content length], @"the updated index should be within the content boundary");
	}
	else 
	{
		plainGlyph = [self generateGlyphWithContent:[_content substringWithRange:NSMakeRange(index, [_content length] - index)]];
		index = [_content length];
	}
	
	if (plainGlyph != nil) 
	{
		NSArray * subGlyphs = [self splitToPrintableGlyphsWithGlyph:plainGlyph];
		if (subGlyphs != nil) 
		{
			[bufferedItems addObjectsFromArray:subGlyphs];
		}
	}
	
	if (matchedGlyph != nil)
	{
		if ([matchedGlyph isKindOfClass:[GHPrintableGlyph class]])
		{
			NSArray * subGlyphs = [self splitToPrintableGlyphsWithGlyph:matchedGlyph];
			if (subGlyphs != nil) 
			{
				[bufferedItems addObjectsFromArray:subGlyphs];
			}
		}
		else if ([matchedGlyph isKindOfClass:[GHLinebreak class]])
		{
			overallHeight += 20.0f;
			startPos = 0.0f;
			[bufferedItems addObject:matchedGlyph];
		}
		else if ([matchedGlyph isKindOfClass:[GHChangeColor class]])
		{
			//TODO: remove hardcode 1
			if ([matchedGlyph.content isEqualToString:@"1"]) 
			{
				currentColor = ((GHChangeColor *)matchedGlyph).color;
			}
			[bufferedItems addObject:matchedGlyph];
		}
		else
		{
			[bufferedItems addObject:matchedGlyph];
		}

	}
}

- (NSArray *)splitToPrintableGlyphsWithGlyph:(GHGlyph *)glyph
{
	//TODO: some special ansi format like >1b[0;20 no end character sucha as m or h
	//NSAssert([glyph isKindOfClass:[GHPrintableGlyph class]], @"glyph should be kind of printable glyph");
	if (![glyph isKindOfClass:[GHPrintableGlyph class]]) 
	{
		return nil;
	}
	
	NSMutableArray * mutableGlyphArray = [[NSMutableArray alloc] init];
	if (_isShownPic && [glyph isKindOfClass:[GHHyperLink class]]) 
	{
		GHHyperLink * link = (GHHyperLink *)glyph;
		NSString * urlString = link.url.absoluteString;
		if (([urlString hasPrefix:@"http://bbs.fudan.sh.cn"] || [urlString hasPrefix:@"http://bbs.fudan.edu.cn"]) &&
			([urlString hasSuffix:@".jpg"] || [urlString hasSuffix:@".JPG"] || [urlString hasSuffix:@".png"] || [urlString hasSuffix:@".PNG"])) 
		{
			GHImage * imageGlyph = [[GHImage alloc] initWithURL:link.url];
			imageGlyph.rect = CGRectMake(0.0f, overallHeight, 320.0f, 320.0f);
			startPos = 0.0f;
			overallHeight += imageGlyph.rect.size.height;
			[mutableGlyphArray addObject:imageGlyph];
			[imageGlyph release];
			NSArray * result = [[NSArray alloc] initWithArray:mutableGlyphArray];
			[mutableGlyphArray release];
			return [result autorelease];
		}
	}
	
	NSString * candidate = glyph.content;
	NSAssert(candidate != nil, @"no nil");
	while ([candidate length] != 0) 
	{
		CGSize candidateSize = [candidate sizeWithFont:[UIFont systemFontOfSize:14.0f]];
		GHPrintableGlyph * subGlyph = nil;
		if (candidateSize.width <= 320.0f - startPos) 
		{
			if ([glyph isKindOfClass:[GHText class]]) 
			{
				GHText * text = [[GHText alloc] init];
				text.content = candidate;
				subGlyph = text;
			}
			else if ([glyph isKindOfClass:[GHHyperLink class]])
			{
				NSURL * url = ((GHHyperLink *)glyph).url;
				GHHyperLink * link = [[GHHyperLink alloc] initWithUrl:url];
				link.content = candidate;
				subGlyph = link;
			}
			else {
				NSAssert(NO, @"can't be here");
			}

			CGSize size = [subGlyph.content sizeWithFont:[UIFont systemFontOfSize:14.0f]];
			CGRect rect = CGRectMake(startPos, overallHeight, size.width, size.height);
			subGlyph.rect = rect;
			subGlyph.color = currentColor;
			[mutableGlyphArray addObject:subGlyph];
			candidate = nil;
			startPos += candidateSize.width;
			break;
		}
		else 
		{
			int forceLineBreakIndex = [self lengthOfString:candidate WithInWidth:320.0f - startPos];
			NSString * content = [candidate substringToIndex:forceLineBreakIndex];
			if ([content isEqualToString:@""]) 
			{
				overallHeight += 20.0f;
				startPos = 0.0f;
			}
			else
			{
				if ([glyph isKindOfClass:[GHText class]]) 
				{
					GHText * text = [[GHText alloc] init];
					text.content = content;
					subGlyph = text;
				}
				else if ([glyph isKindOfClass:[GHHyperLink class]])
				{
					NSURL * url = ((GHHyperLink *)glyph).url;
					GHHyperLink * link = [[GHHyperLink alloc] initWithUrl:url];
					link.content = content;
					subGlyph = link;
				}
				else {
					NSAssert(NO, @"can't be here");
				}
				
				CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0f]];
				CGRect rect = CGRectMake(startPos, overallHeight, size.width, size.height);
				subGlyph.rect = rect;
				subGlyph.color = currentColor;
				startPos += size.width;
				[mutableGlyphArray addObject:subGlyph];
			}
			candidate = [candidate substringFromIndex:forceLineBreakIndex];
		}
	}
	
	NSArray * result = [[NSArray alloc] initWithArray:mutableGlyphArray];
	[mutableGlyphArray release];
	return [result autorelease];
}

- (GHGlyph *) generateGlyphWithContent:(NSString *)content
{
	if ([content hasPrefix:@"http"]) 
	{
		GHHyperLink * glyph = [[[GHHyperLink alloc] initWithUrl:[NSURL URLWithString: content]] autorelease];
		return glyph;
	}
	else if ([content hasPrefix:@"\n"])
	{
		GHLinebreak * glyph = [[[GHLinebreak alloc] init] autorelease];
		glyph.content = [content copy];
		return glyph;
	}
	else if ([content hasPrefix:@">1b["])
	{
		GHChangeColor * glyph = [[[GHChangeColor alloc] init] autorelease];
		
		if ([content hasSuffix:@"m"])
		{
			if (_needAnsiColor) 
			{
				NSArray * colorArray = [content componentsMatchedByRegex:_colorCodeRegex];
				if ([colorArray count] > 0) 
				{
					int colorCode = [[colorArray lastObject] intValue] % 10;
					switch (colorCode) {
						case 0:
							glyph.color = [UIColor blackColor];
							break;
						case 1:
							glyph.color = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
							break;
						case 2:
							glyph.color = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
							break;
						case 3:
							glyph.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.0 alpha:1.0];
							break;
						case 4:
							glyph.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.5 alpha:1.0];
							break;
						case 5:
							glyph.color = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:1.0];
							break;
						case 6:
							glyph.color = [UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:1.0];
							break;
						case 7:
							glyph.color = [UIColor blackColor];
							break;
						default:
							glyph.color = [UIColor blackColor];
							break;
					}
					glyph.content = [@"1" copy];
					return glyph;
				}
				else 
				{
					if ([content isEqualToString:@">1b[0m"] || [content isEqualToString:@">1b[m"]) 
					{
						glyph.color = [UIColor blackColor];
						glyph.content = [@"1" copy];
					}
					else 
					{
						glyph.content = [@"0" copy];					
					}
					
					
					return glyph;
				}
			}
			else 
			{
				glyph.color = [UIColor blackColor];
				glyph.content = [@"1" copy];
				return glyph;
			}
		}
		else 
		{
			glyph.content = [@"0" copy];
			return glyph;
		}
	}
	else 
	{
		GHText * glyph = [[[GHText alloc] init] autorelease];
		glyph.content = [content copy];
		return glyph;
	}
}

- (int) lengthOfString:(NSString *)string WithInWidth:(float)width
{
	NSAssert(string != nil, @"string shouldn't be nil");
	NSAssert(width > -0.1f, @"the available width should be large than 0.");
	int leftBound = 0;
	int rightBound = [string length];
	NSString * candidate = string;
	while (leftBound + 1 < rightBound)
	{
		int mid = (leftBound + rightBound) / 2;
		candidate = [string substringWithRange:NSMakeRange(0, mid)];
		CGSize size = [candidate sizeWithFont:[UIFont systemFontOfSize:14.0f]];
		if (size.width > width) 
		{
			rightBound = mid;
		}
		else 
		{
			leftBound = mid;
		}
	}
	return leftBound;
}

- (float) getOverallHeight
{
	return overallHeight;
}

- (void) dealloc
{
	[_glyphRegex release];
	[_colorCodeRegex release];
	[_content release];
	[super dealloc];
}
@end

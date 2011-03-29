//
//  GHImage.m
//  ghbbs
//
//  Created by hangchenqun on 2/18/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import "GHImage.h"
#import "RegexKitLite.h"
#import "PictureManager.h"

@implementation GHImage
- (id) initWithURL:(NSURL *)url
{
	if (self = [super init])
	{
		//_content = [[NSString alloc] initWithString:@"正在载入"];
		_content = [@"loading..." retain];
		_url = [url retain];
		NSMutableString * urlStr = [NSMutableString stringWithString: [url absoluteString]];
		[urlStr replaceOccurrencesOfRegex:@"http://bbs.fudan.(?:sh|edu).cn/upload/" withString:@"http://bbs.fudan.sh.cn/img3/"];
		_thumbnailURL = [[NSURL alloc] initWithString:urlStr];
	}
	return self;

}

- (void) draw
{
	NSAssert(_thumbnailURL != nil, @"shouldn't be nil");
	NSLog(@"%@", _thumbnailURL);
	UIImage * img = [[PictureManager sharedInstance] getPicture:[_thumbnailURL absoluteString]];
	if (img == nil) 
	{
		img = [UIImage imageNamed:@"downloading.png"];
	}
	_rect.size = img.size;
	[img drawInRect:_rect];
}

- (void) dealloc
{
	[_url release];
	[_thumbnailURL release];
	[super dealloc];
}

@end

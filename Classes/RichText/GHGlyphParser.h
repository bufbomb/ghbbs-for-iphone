//
//  GHContentParser.h
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHGlyph.h"

@interface GHContentParser : NSObject {
	NSString * _content;
	BOOL _isShownPic;
	BOOL _needAnsiColor;
	long index;
	NSMutableArray * bufferedItems;
	/* Use startPos to store the start printable area width in single line */
	float startPos;
	UIColor * currentColor;
	NSString * _glyphRegex;
	NSString * _colorCodeRegex;
	float overallHeight;
}

- (id) initWithContent:(NSString *)content ShowPicture:(BOOL)isShownPic NeedAnsiColor:(BOOL)needAnsiColor;
- (GHGlyph *) nextItem;
- (float) getOverallHeight;
@end

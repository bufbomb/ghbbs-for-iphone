//
//  GHDocument.h
//  ghbbs
//
//  Created by hangchenqun on 2/1/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHGlyph.h"

@interface GHDocument : NSObject {
	NSMutableArray * _glyphs;
	CGRect _rect;
	BOOL _isShownPic;
	BOOL _needAnsiColor;
}

- (id) initWithShowPicture:(BOOL)isShownPic needAnsiColor:(BOOL)needAnsiColor;
- (void) draw;
- (void) formatWithText:(NSString *)allText;

@property CGRect rect;
@end

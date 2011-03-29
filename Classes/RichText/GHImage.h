//
//  GHImage.h
//  ghbbs
//
//  Created by hangchenqun on 2/18/11.
//  Copyright 2011 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHPrintableGlyph.h"

@interface GHImage : GHPrintableGlyph {
	NSURL * _url;
	NSURL * _thumbnailURL;
}

- (id) initWithURL:(NSURL *)url;
@end
